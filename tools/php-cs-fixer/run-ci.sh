IFS='
'
CHANGED_FILES=$(git diff --name-only --diff-filter=ACMRTUXB "${CI_MERGE_REQUEST_DIFF_BASE_SHA}..HEAD" | grep -v "tests/*")
EXTRA_ARGS=$(printf -- '--path-mode=intersection\n--\n%s' "${CHANGED_FILES}")
./tools/php-cs-fixer/vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.dist.php -v --dry-run --using-cache=no --diff --format=gitlab ${EXTRA_ARGS} > php-cs-fixer.json
