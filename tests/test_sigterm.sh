#!/bin/bash

: ${NODE_VERSION?"NODE_VERSION has not been set."}

set -x

function clean() {
  docker rm -f meteor-app
  docker rm -f mongo
  rm -rf hello
}

cd /tmp
clean

meteor create --release 2.0 hello
cd hello
echo "process.on('SIGTERM', function () { console.log('SIGTERM RECEIVED'); });" >> server/main.js

meteor build --architecture=os.linux.x86_64 ./

docker run -d \
    --name mongo \
    -p 27017:27017 \
    --network=host \
    mongo:latest

docker run -d \
    --name meteor-app \
    -e MONGO_URL=mongodb://localhost:27017/ \
    -e ROOT_URL=http://yourapp_dot_com \
    -v /tmp/hello/:/bundle \
    -p 8080:80 \
    wvanooijen92/meteord:base

sleep 50

docker stop meteor-app
found=`docker logs meteor-app | grep -c "SIGTERM RECEIVED"`
clean

if [[ $found != 1 ]]; then
  echo "Failed: Meteor app"
  exit 1
fi
