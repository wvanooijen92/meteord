#!/bin/bash

: ${NODE_VERSION?"NODE_VERSION has not been set."}

set -x

function clean() {
  docker rm -f meteor-app
  docker rm -f mongo
  docker rmi -f meteor-app-image
  rm -rf hello
}

cd /tmp
clean

meteor create --release 2.0 hello
cd hello
echo "FROM wvanooijen92/meteord:node-${NODE_VERSION}-onbuild" > Dockerfile

docker build -t meteor-app-image ./
docker run -d \
    --name mongo \
    -p 27017:27017 \
    --network=host \
    mongo:latest

docker run -d \
    --name meteor-app \
    -e MONGO_URL=mongodb://localhost:27017/ \
    -e ROOT_URL=http://yourapp_dot_com \
    --network=host \
    -p 8080:80 \
    meteor-app-image

sleep 50

appContent=`docker logs meteor-app`
clean

if [[ $appContent != *"=> Starting meteor app on port:80"* ]]; then
  echo "Failed: Meteor app"
  exit 1
fi
