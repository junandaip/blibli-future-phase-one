#!/bin/bash
# This script is run by wd_escalation_command to bring down the virtual IP on other pgpool nodes
# before bringing up the virtual IP on the new active pgpool node.

set -o xtrace

PGPOOLS=(db1 db2)

VIP=192.168.56.200
DEVICE=enp0s8

for pgpool in "${PGPOOLS[@]}"; do
    [ "$HOSTNAME" = "$pgpool" ] && continue

    ssh -T -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null postgres@$pgpool -i ~/.ssh/id_rsa_pgpool "
        /usr/bin/sudo /sbin/ip addr del $VIP/24 dev $DEVICE
    "
done
exit 0