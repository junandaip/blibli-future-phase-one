#!/bin/bash

workdir=/home/server/ansible

cd $workdir 
ansible-playbook playbook.yml -e @group_vars/vault.yml -vv