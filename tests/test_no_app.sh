#!/bin/bash

: ${NODE_VERSION?"NODE_VERSION has not been set."}

set -x

function clean() {
  docker rm -f no_app
}

cd /tmp
clean

docker run -d \
    --name no_app \
    -e ROOT_URL=http://no_app \
    -p 9090:80 \
    "abernix/meteord:node-${NODE_VERSION}-base"

sleep 10

appContent=`docker logs no_app`
clean

if [[ $appContent != *"You don't have an meteor app"* ]]; then
  echo "Failed: To check whether actual meteor bundle exists or not"
  exit 1
fi