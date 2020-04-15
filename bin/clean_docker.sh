#!/bin/bash

echo ""

eval $(egrep -v '^#' .env | xargs)

if [ -z $PROJECT_NAME ]; then echo "PROJECT_NAME is unset or empty, plesase add it to your .env"; exit 1; fi

read -p "This wil delete *ALL* Docker data (containers, images, volumes) with prefix $PROJECT_NAME. DO YOU WANT TO CONTINUE? (y/n)?" choice
case "$choice" in
  y|Y|yes|YES )
    docker kill $(docker ps -q -f name=$PROJECT_NAME)
    docker rm -f $(docker ps -a -q f name=$PROJECT_NAME)
    docker rmi -f $(docker images -q -f "reference=$PROJECT_NAME*")
    docker system prune -f
    docker volume rm $(docker volume ls -f dangling=true)
    echo ""
    echo "Done!";;
  n|N ) echo "no";;
  * ) echo "invalid";;
esac

