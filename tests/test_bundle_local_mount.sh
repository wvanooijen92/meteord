#!/bin/sh

set -x

clean() {
  docker rm -f localmount
  rm -rf localmount
}

cd /tmp
clean

meteor create localmount
cd localmount
meteor build --architecture=os.linux.x86_64 ./
pwd
ls -la

docker run -d \
    --name localmount \
    -e ROOT_URL=http://localmount_app \
    -v /tmp/localmount:/bundle \
    -p 9090:80 \
    "abernix/meteord:base"

sleep 50

appContent=`curl http://localhost:9090`
clean

if test '"'${appContent#*"localmount_app"}'"' != "$appContent"; then
  echo "Failed: Bundle local mount"
  exit 1
fi