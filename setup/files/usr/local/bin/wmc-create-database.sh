#!/bin/bash

regex="/(wmc|projects)/([^/]+)/([^/]+)"

if [[ "$(pwd)" =~ $regex ]]; then
    client=${BASH_REMATCH[2]}
    project=${BASH_REMATCH[3]}

    database="${client}_${project}"

    echo "Doing setup for database '${database}'"

    [ -n "$(mysql -BNe "SHOW DATABASES LIKE '${database}'")" ] || mysql -e "CREATE DATABASE ${database};"
    echo "host='localhost'
user='root'
pass='root'
name='${database}'" > confs/database.ini
else
    echo "Unable to guess database name for $(pwd)" >&2
    exit 1
fi
