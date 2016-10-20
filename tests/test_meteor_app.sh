#!/bin/sh

set -e
set -x

trap "echo Failed: Meteor app" EXIT

doalarm () { perl -e 'alarm shift; exec @ARGV' "$@"; }

clean() {
  docker rm -f meteor-app 2> /dev/null || true
  docker rmi -f meteor-app-image 2> /dev/null || true
  rm -rf meteord-app-test || true
}

cd /tmp
clean

look_for="==== METEORDTEST ===="

meteor create meteord-app-test
cd meteord-app-test
echo "FROM abernix/meteord:base" > Dockerfile
cat <<EOM > server/main.js
require('meteor/meteor').Meteor.startup(() => console.log('$look_for'));
EOM

docker build -t meteor-app-image ./
docker run -d \
    --name meteor-app \
    -e ROOT_URL=http://yourapp_dot_com \
    -p 8080:80 \
    meteor-app-image

sh -c 'docker logs -f meteor-app | grep --line-buffered -m1 "${look_for}"' || true
sleep 5
curl -s http://localhost:8080 2>&1 > /dev/null
clean
trap - EXIT
