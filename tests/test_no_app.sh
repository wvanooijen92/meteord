#!/bin/sh

set -x

clean() {
  docker rm -f meteord-test-no_app 2> /dev/null || true
}

cd /tmp
clean

docker run -d \
    --name meteord-test-no_app \
    -e ROOT_URL=http://no_app \
    -p 9090:80 \
    "abernix/meteord:base"

sleep 10

appContent=`docker logs meteord-test-no_app`
clean

if test '"'${appContent#*"You don't have an meteor app"}'"' != "$appContent"; then
  echo "Failed: To check whether actual meteor bundle exists or not"
  exit 1
fi