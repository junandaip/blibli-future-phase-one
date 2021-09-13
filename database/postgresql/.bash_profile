[ -f /etc/profile ] && source /etc/profile
PGDATA=/var/lib/pgsql/13/data
export PGDATA
# If you want to customize your settings,
# Use the file below. This is not overridden
# by the RPMS.
[ -f /var/lib/pgsql/.pgsql_profile ] && source /var/lib/pgsql/.pgsql_profile
PATH=$PATH:/usr/pgsql-13/bin/
export PATH
