#!/bin/bash

POSTGRES_SERVICE=postgres
REDIS=redis

echo " ************************** (1) Installed versions **************************" > debug.txt
uname -a >> debug.txt
python_version=$(python --version 2>&1)
echo $python_version >> debug.txt
docker -v >> debug.txt
docker-compose -v >> debug.txt
git --version >> debug.txt
echo " ************************** (2) network connectivity **************************" >> debug.txt
ping google.de -c 3 >> debug.txt
echo " ************************** (3) Memory situation **************************" >> debug.txt
top -l 1 -s 0 | awk ' /Processes/ || /PhysMem/ || /Load Avg/{print}' >> debug.txt
echo " ************************** (4) Content of .env **************************" >> debug.txt
cat .env >> debug.txt
echo " ************************** (5) Ports access **************************" >> debug.txt
echo " ***** 5432 *****" >> debug.txt
lsof -i :5432 >> debug.txt || true
echo " ***** 6379 *****" >> debug.txt
lsof -i :6379 >> debug.txt || true
echo " ***** 8000 *****" >> debug.txt
lsof -i :8000 >> debug.txt || true
echo " ***** 8080 *****" >> debug.txt
lsof -i :8080 >> debug.txt || true
echo " ************************** (6) Docker status **************************" >> debug.txt
docker images >> debug.txt
echo ""  >> debug.txt
docker ps >> debug.txt
echo ""  >> debug.txt
docker volume ls >> debug.txt

for i in `docker ps -a -q`;
    do
        echo "" >> debug.txt
        echo "" >> debug.txt
        echo "" >> debug.txt
        echo " ***** $i *****" >> debug.txt
        docker logs $i >> debug.txt 2>&1
    done

pbcopy < debug.txt || true

echo ""
echo "All done, content of debug.txt was copied to clip board!"