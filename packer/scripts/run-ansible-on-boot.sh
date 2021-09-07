#!/bin/bash

command="@reboot /bin/bash /home/server/start-ansible.sh"

sudo -u server /usr/bin/crontab -l | { /usr/bin/cat; echo $command; } | /usr/bin/crontab -