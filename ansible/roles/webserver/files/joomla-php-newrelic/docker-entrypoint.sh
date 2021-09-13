#!/bin/bash

set -e

if ! [ -e index.php -a \( -e libraries/cms/version/version.php -o -e libraries/src/Version.php \) ]; then
    echo >&2 "Joomla not found in $(pwd) - copying now..."
  
    rsync -av --progress /usr/src/joomla/ $(pwd)
    
    echo >&2 "Complete! Joomla has been successfully copied to $(pwd)"
fi

exec "$@"