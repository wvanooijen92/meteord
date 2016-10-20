#!/bin/sh

set -x
set -e

clean() {
  docker rm -f meteord-test-phantomjs_check 2> /dev/null || true
}

clean
docker run  \
    --name meteord-test-phantomjs_check \
    --entrypoint="/bin/sh" \
    "abernix/meteord:base" -c 'phantomjs -h'

sleep 5

appContent=`docker logs phantomjs_check`
clean

if test '"'${appContent#*"GhostDriver"}'"' != "$appContent"; then
  echo "Failed: Phantomjs Check"
  exit 1
fi