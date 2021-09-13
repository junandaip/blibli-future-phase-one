#!/bin/bash

cat << EOT >> /etc/hosts
192.168.56.190  haproxy
192.168.56.191  web1
192.168.56.192  web2
192.168.56.193  db1
192.168.56.194  db2
192.168.56.199  control-node
192.168.56.200  vip
EOT