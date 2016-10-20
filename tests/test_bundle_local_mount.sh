#!/bin/sh

set -x
set -e

trap "echo Failed: Bundle local mount" EXIT

clean() {
  docker rm -f meteord-test-localmount 2> /dev/null || true
  rm -rf meteord-test-localmount || true
}

cd /tmp
clean

meteor create meteord-test-localmount
cd meteord-test-localmount
meteor build --architecture=os.linux.x86_64 ./
pwd

docker run -d \
    --name meteord-test-localmount \
    -e ROOT_URL=http://localmount_app \
    -v /tmp/meteord-test-localmount:/bundle \
    -p 9090:80 \
    "abernix/meteord:base"

sleep 50

appContent=`curl http://localhost:9090`
clean

if test '"'${appContent#*"localmount_app"}'"' != "$appContent"; then
  echo "Failed: Bundle local mount"
  exit 1
fi