#!/bin/bash

# This scripts creates a database and a user with the same name. Passwort is always 'secret'.

echo ""

POSTGRES_SERVICE=postgres

eval $(egrep -v '^#' .env | xargs)

if [ -z $PROJECT_NAME ]; then echo "PROJECT_NAME is unset or empty, plesase add it to your .env"; exit 1; fi

read -p "What database? " DATABASE_NAME

if [ "$( psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DATABASE_NAME'" )" = '1' ]
then
    pg_dump --clean -h localhost -U postgres -d $DATABASE_NAME > "$DATABASE_NAME.sql"
    echo "Export finished."
else
    echo "Database not found, canceled export."
fi
