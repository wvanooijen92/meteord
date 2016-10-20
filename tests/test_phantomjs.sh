#!/bin/sh

set -x

clean() {
  docker rm -f phantomjs_check 2> /dev/null
}

clean
docker run  \
    --name phantomjs_check \
    --entrypoint="/bin/sh" \
    "abernix/meteord:base" -c 'phantomjs -h'

sleep 5

appContent=`docker logs phantomjs_check`
clean

if test '"'${appContent#*"GhostDriver"}'"' != "$appContent"; then
  echo "Failed: Phantomjs Check"
  exit 1
fi