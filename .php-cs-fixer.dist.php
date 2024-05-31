<?php

require_once __DIR__ . '/tools/php-cs-fixer/vendor/autoload.php';

return (new PhpCsFixer\Config())
    ->setRules([
        '@PHP81Migration' => true,
        '@Symfony' => true,
        '@Symfony:risky' => true,
        'protected_to_private' => false,
        'native_constant_invocation' => ['strict' => false],
        'nullable_type_declaration_for_default_null_value' => ['use_nullable_type_declaration' => false],
        'no_superfluous_phpdoc_tags' => ['remove_inheritdoc' => true],
        'modernize_strpos' => true,
        'get_class_to_class_keyword' => true,
        'single_line_throw' => false,
        'multiline_comment_opening_closing' => true,
        'phpdoc_align' => ['align' => 'left'],
        'trailing_comma_in_multiline' => ['elements' => ['arguments', 'arrays', 'match', 'parameters']],
        'heredoc_indentation' => ['indentation' => 'same_as_start'],
        'is_null' => false,
        'concat_space' => ['spacing' => 'one'],
        'global_namespace_import' => ['import_classes' => true, 'import_constants' => true, 'import_functions' => true],
        'multiline_whitespace_before_semicolons' => ['strategy' => 'new_line_for_chained_calls'],
    ])
    ->setRiskyAllowed(true)
    ->setFinder(
        (new PhpCsFixer\Finder())
            ->in(__DIR__ . '/src')
            ->append([__FILE__]),
    )
    ->setCacheFile('.php-cs-fixer.cache')
;
