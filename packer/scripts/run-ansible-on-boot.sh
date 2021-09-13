#!/bin/bash

command="@reboot /bin/bash /home/server/start-ansible.sh"

sudo -u server /usr/bin/crontab -l | { sudo -u server /usr/bin/cat; echo $command; } | sudo -u server /usr/bin/crontab -