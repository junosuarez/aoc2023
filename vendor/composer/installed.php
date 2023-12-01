<?php return array(
    'root' => array(
        'name' => '__root__',
        'pretty_version' => '1.0.0+no-version-set',
        'version' => '1.0.0.0',
        'reference' => NULL,
        'type' => 'library',
        'install_path' => __DIR__ . '/../../',
        'aliases' => array(),
        'dev' => true,
    ),
    'versions' => array(
        '__root__' => array(
            'pretty_version' => '1.0.0+no-version-set',
            'version' => '1.0.0.0',
            'reference' => NULL,
            'type' => 'library',
            'install_path' => __DIR__ . '/../../',
            'aliases' => array(),
            'dev_requirement' => false,
        ),
        'facebook/hhvm-autoload' => array(
            'dev_requirement' => false,
            'replaced' => array(
                0 => '1.*',
            ),
        ),
        'hhvm/hhvm-autoload' => array(
            'pretty_version' => 'v3.3.2',
            'version' => '3.3.2.0',
            'reference' => '186d1fc5d5bf69caebaacac5c80a69e3c08f50d4',
            'type' => 'composer-plugin',
            'install_path' => __DIR__ . '/../hhvm/hhvm-autoload',
            'aliases' => array(),
            'dev_requirement' => false,
        ),
        'hhvm/hsl' => array(
            'pretty_version' => 'v4.108.1',
            'version' => '4.108.1.0',
            'reference' => '3b4375e6adf63ac9171721b031b662dd3524c5bb',
            'type' => 'library',
            'install_path' => __DIR__ . '/../hhvm/hsl',
            'aliases' => array(),
            'dev_requirement' => false,
        ),
    ),
);
