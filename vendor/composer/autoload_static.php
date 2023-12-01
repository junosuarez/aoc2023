<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInitc71c3498a66f5d99c10f572de3f8a928
{
    public static $classMap = array (
        'Composer\\InstalledVersions' => __DIR__ . '/..' . '/composer/InstalledVersions.php',
        'Facebook\\AutoloadMap\\ComposerPlugin' => __DIR__ . '/..' . '/hhvm/hhvm-autoload/ComposerPlugin.php',
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->classMap = ComposerStaticInitc71c3498a66f5d99c10f572de3f8a928::$classMap;

        }, null, ClassLoader::class);
    }
}
