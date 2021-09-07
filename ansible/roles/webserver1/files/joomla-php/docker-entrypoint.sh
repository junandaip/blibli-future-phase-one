#!/bin/bash

set -e

if ! [ -e index.php -a \( -e libraries/cms/version/version.php -o -e libraries/src/Version.php \) ]; then
    echo >&2 "Joomla not found in $(pwd) - copying now..."
  
    rsync -av --progress --exclude="installation" --exclude="configuration.php" /usr/src/joomla/ $(pwd)

        if [ ! -e .htaccess ]; then
            # NOTE: The "Indexes" option is disabled in the php:apache base image so remove it as we enable .htaccess
            sed -r 's/^(Options -Indexes.*)$/#\1/' htaccess.txt > .htaccess
            chown www-data:www-data .htaccess
        fi
    
    echo >&2 "Complete! Joomla has been successfully copied to $(pwd)"
fi

exec "$@"
