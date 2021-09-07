#!/bin/bash

password="future5"
workdir=/home/server/ansible

cd $workdir 
ansible-playbook playbook.yml --extra-vars "ansible_password=${password}"