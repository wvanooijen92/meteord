#!/bin/sh

base_app_name="meteord-test-phantomjs_check"

set -x
set -e
my_dir=`dirname $0`
. ${my_dir}/lib.sh

clean() {
  docker rm -f "${base_app_name}" 2> /dev/null || true
}

clean
docker run  \
    --name "${base_app_name}" \
    --entrypoint="phantomjs -h" \
    "abernix/meteord:base"

sleep 5

docker_logs_has "${base_app_name}" "GhostDriver"
clean
