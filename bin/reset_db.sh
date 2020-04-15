#!/bin/bash

# This scripts creates a database and a user with the same name. Passwort is always 'secret'.

echo ""

POSTGRES_SERVICE=postgres

eval $(egrep -v '^#' .env | xargs)

if [ -z $PROJECT_NAME ]; then echo "PROJECT_NAME is unset or empty, plesase add it to your .env"; exit 1; fi

read -p "What database? " DATABASE_NAME

if [ "$( psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DATABASE_NAME'" )" = '1' ]
then
    read -p "This wil DROP your database '$DATABASE_NAME' deleting *ALL* DATA. DO YOU WANT TO CONTINUE? (y/n)?" choice
    case "$choice" in
    y|Y|yes|YES ) 
        psql -h localhost -U postgres -d postgres -c "REVOKE CONNECT ON DATABASE $DATABASE_NAME FROM public;"
        psql -h localhost -U postgres -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$1';"
        psql -h localhost -U postgres -d postgres -c "DROP DATABASE IF EXISTS $DATABASE_NAME;" 
        psql -h localhost -U postgres -d postgres -c "DROP USER $DATABASE_NAME;";;
    n|N ) echo "Okay. Nothing was deleted." || exit 1;;
    * ) echo "invalid" || exit 1;;
    esac    
else
    echo ""
fi

psql -h localhost -U postgres -d postgres -c "CREATE DATABASE $DATABASE_NAME;" || exit 1
psql -h localhost -U postgres -d postgres -c "CREATE USER $DATABASE_NAME WITH PASSWORD 'secret' SUPERUSER;" || exit 1
psql -h localhost -U postgres -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE $DATABASE_NAME TO $DATABASE_NAME;" || exit 1
echo ""
echo "Done! You can now use DATABASE_URL=postgresql://$DATABASE_NAME:secret@postgres/$DATABASE_NAME"

