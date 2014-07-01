#!/bin/bash

regex="/(?:wmc|projects)/([^/]+)/([^/]+)"

if [[ "$(pwd)" =~ $regex ]]; then
    client=${BASH_REMATCH[1]}
    project=${BASH_REMATCH[2]}

    database="${client}_${project}"

    echo "Doing setup for database '${database}'"

    mysql -BNe "SHOW DATABASES LIKE '${database}'" || mysql -e "CREATE DATABASE ${database};"
    echo "host='localhost'
user='root'
pass='root'
name='${database}'
" > confs/database.ini
else
    echo "Unable to guess database name for $(pwd)" >&2
    exit 1
fi
