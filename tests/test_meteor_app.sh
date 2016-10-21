#!/bin/sh

set -e
set -x

base_app_name=meteord-test-app

trap "echo Failed: Meteor app" EXIT

doalarm () { perl -e 'alarm shift; exec @ARGV' "$@"; }

clean() {
  docker rm -f "${base_app_name}" 2> /dev/null || true
  docker rmi -f "${base_app_name}-image" 2> /dev/null || true
  rm -rf ${base_app_name} || true
}

cd /tmp
clean

look_for="==== METEORDTEST ===="

meteor create "${base_app_name}"
cd "${base_app_name}"
echo "FROM abernix/meteord:base" > Dockerfile
cat <<EOM > server/main.js
require('meteor/meteor').Meteor.startup(() => console.log('$look_for'));
EOM

test_root_url_hostname=yourapp_dot_com

docker build -t "${base_app_name}" -image ./
docker run -d \
    --name "${base_app_name}" \
    -e ROOT_URL=http://$test_root_url_hostname \
    -p 8080:80 \
    "${base_app_name}-image"

doalarm 5 sh -c \
  'docker logs -f ${base_app_name} | grep --line-buffered -m1 "${look_for}"' \
  || true

sleep 1
curl -s http://localhost:8080 | grep ${test_root_url_hostname} 2>&1 > /dev/null
clean
trap - EXIT
