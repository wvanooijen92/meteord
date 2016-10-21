#!/bin/sh

base_app_name="meteord-test-no_app"

set -x
set -e
my_dir=`dirname $0`
. ${my_dir}/lib.sh

clean() {
  docker rm -f "${base_app_name}" 2> /dev/null || true
}

cd /tmp
clean

docker run -d \
    --name "${base_app_name}" \
    -e ROOT_URL=http://no_app \
    -p 9090:80 \
    "abernix/meteord:base"

docker_logs_has "${base_app_name}" "You don't have an meteor app"
clean
