#!/bin/sh

set -x

clean() {
  docker rm -f web
}

cd /tmp
clean

docker run -d \
    --name web \
    -e ROOT_URL=http://web_app \
    -e BUNDLE_URL=https://abernix-meteord-tests.s3-us-west-2.amazonaws.com/meteord-test-bundle.tar.gz \
    -p 9090:80 \
    "abernix/meteord:base"

sleep 50

appContent=`curl http://localhost:9090`
clean

if [ test '"'${appContent#*"web_app"}'"' != "$appContent" ]; then
  echo "Failed: Bundle web"
  exit 1
fi