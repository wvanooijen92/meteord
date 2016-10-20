#!/bin/sh

set -x

clean() {
  docker rm -f meteor-app 2> /dev/null
  docker rmi -f meteor-app-image 2> /dev/null
  rm -rf hello
}

cd /tmp
clean

meteor create hello
cd hello
echo "FROM abernix/meteord:base" > Dockerfile

docker build -t meteor-app-image ./
docker run -d \
    --name meteor-app \
    -e ROOT_URL=http://yourapp_dot_com \
    -p 8080:80 \
    meteor-app-image

sleep 50

appContent=`curl http://localhost:8080`
clean

if test '"'${appContent#*"yourapp_dot_com"}'"' != "$appContent"; then
  echo "Failed: Meteor app"
  exit 1
fi