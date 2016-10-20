#!/bin/sh

set -x
set -e

clean() {
  docker rm -f meteord-test-web 2> /dev/null || true
}

cd /tmp
clean

docker run -d \
    --name meteord-test-web \
    -e ROOT_URL=http://web_app \
    -e BUNDLE_URL=https://abernix-meteord-tests.s3-us-west-2.amazonaws.com/meteord-test-bundle.tar.gz \
    -p 9090:80 \
    "abernix/meteord:base"

sleep 50

appContent=`curl http://localhost:9090`
docker log meteord-test-web
clean

if test '"'${appContent#*"web_app"}'"' != "$appContent"; then
  echo "Failed: Bundle web"
  exit 1
fi