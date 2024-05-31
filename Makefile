default: help

################# ALIAS #################

DC := $(shell docker --help | grep -q "^\s*compose" && echo "docker compose" || echo "docker-compose")
INTERACTIVE := $(shell [ -t 0 ] && echo 1)
ifdef INTERACTIVE
	DC_PHP := $(DC) exec php # Docker container php executable
else
	DC_PHP := $(DC) exec -T php # Docker container php executable
endif
SYM := $(DC_PHP) php bin/console # Symfony executable

#################  COMMANDS #################

##@ Helpers
.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

KNOWN_TARGETS = sf
ARGS := $(filter-out $(KNOWN_TARGETS),$(MAKECMDGOALS))
.DEFAULT: ;: do nothing
.SUFFIXES:
.PHONY: dc-images
sf: ## use Symfony console (with option add "")
	$(COMMAND) $(SYM) $(ARGS)

##@ Docker
.PHONY: dc-images
dc-images: ## Show containers
	$(DC) images

.PHONY: dc-network
dc-network: ## Inspect network
	docker network inspect apicodecodex_default

.PHONY: dc-php
dc-php: ## Connect to the php container
	$(DC_PHP) sh

.PHONY: dc-mysql
dc-mysql: ## Connect to the mysql container
	docker compose exec mysql sh

##@ Project
.PHONY: pj-install
pj-install: ## Install the project
	$(MAKE) pj-start
	$(DC_PHP) composer install --no-scripts
	$(DC_PHP) composer --working-dir=tools/php-cs-fixer install
	$(SYM) doctrine:database:create
	$(SYM) doctrine:migrations:migrate -n
	$(SYM) doctrine:fixtures:load -n
	$(SYM) lexik:jwt:generate-keypair --skip-if-exists
	@echo "\033[1;32mInstallation completed successfully\033[0m"

.PHONY: pj-start
pj-start: ## Start the project's containers
    ifeq ($(DC),docker-compose)
		$(DC) up -d
    else
		docker compose up -d
    endif

.PHONY: pj-stop
pj-stop: ## Stop the project's containers
    ifeq ($(DC),docker-compose)
		$(DC) down
    else
		docker compose down
    endif

.PHONY: pj-restart
pj-restart: pj-stop pj-start ## Restart the project's containers

.PHONY: pj-update
pj-update: ## Update the project (composer dependencies)
	$(DC_PHP) composer install
	$(DC_PHP) composer --working-dir=tools/php-cs-fixer install

.PHONY: pj-reset
pj-reset: ## Reset the project (remove database, and re-install the project)
	$(MAKE) pj-start
	$(DC_PHP) composer install --no-scripts
	$(DC_PHP) composer --working-dir=tools/php-cs-fixer install
	$(SYM) doctrine:database:drop --if-exists --force
	$(SYM) doctrine:database:create
	$(SYM) cache:clear
	$(SYM) doctrine:migrations:migrate -n
	$(SYM) doctrine:fixtures:load -n

.PHONY: pj-cc
pj-cc: ## Clear the Symfony cache in the container
	$(SYM) cache:clear

.PHONY: pj-stan
pj-stan: ## Run PHPStan analysis (arguments: path=src & level=5)
	$(DC_PHP) vendor/bin/phpstan analyze $(path) -l $(level)

.PHONY: pj-dump
pj-dump: check-dc ## Launch dump server
	$(SYM) server:dump --no-ansi --format="html" > var/dump.html

##@ Database
.PHONY: db-create
db-create: ## Create database
	$(SYM) doctrine:database:create

.PHONY: db-update
db-update: ## Play migrations
	$(SYM) doctrine:migrations:migrate -n

.PHONY: db-drop
db-drop: ## Drop database
	$(SYM) doctrine:database:drop --if-exists --force

.PHONY: db-status
db-status: ## Show status of migrations
	$(SYM) doctrine:migrations:status

.PHONY: db-validate
db-validate: ## Show schema validate
	$(SYM) doctrine:schema:validate

.PHONY: db-fixtures
db-fixtures: ## Reload fixtures in the database
	make db-drop
	make db-create
	make db-update
	$(SYM) doctrine:fixtures:load -q

ARGS = $(filter-out $@,$(MAKECMDGOALS))
.PHONY: db-list
db-list: ## List the available anonymized backups
	$(SYM) restore:db:anonymized -l

BACKUP = $(if $(ARGS),\
	-p $(ARGS),\
	)
.PHONY: db-restore
db-restore: ## Restore the anonymized database
	$(SYM) restore:db:anonymized $(BACKUP)

##@ PHP-CS-Fixer
MODIFIED_FILES = $(shell git diff --name-only --diff-filter=ACMRTUXB | grep -v "tests/*")
LAST_COMMIT_MODIFIED_FILES = $(shell git diff --name-only --diff-filter=ACMRTUXB HEAD~1 | grep -v "tests/*")
TARGET_FILES = $(if $(ARGS),\
	$(ARGS),\
	$(if $(MODIFIED_FILES),\
		$(MODIFIED_FILES),\
		$(LAST_COMMIT_MODIFIED_FILES)))

.PHONY: cs-fix
cs-fix: ## Applies coding styles to a file (ex: make cs-fix src/Kernel.php)
	$(DC_PHP) php -d memory_limit=-1 ./tools/php-cs-fixer/vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.dist.php -v --using-cache=no --diff $(TARGET_FILES)

.PHONY: cs-check
cs-check: ## Checks coding styles for modified files
	$(DC_PHP) php -d memory_limit=-1 ./tools/php-cs-fixer/vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.dist.php -v --dry-run --using-cache=no --diff $(TARGET_FILES)

.PHONY: commit-checks
commit-checks:
	$(MAKE) cs-check $(MODIFIED_FILES)
	$(DC_PHP) php -d memory_limit=-1 bin/phpunit --configuration phpunit.xml.dist --testdox -v --testsuite=tdd,unit
