#!/bin/sh

set -e
set -x

my_dir=`dirname $0`

. ${my_dir}/lib.sh

base_app_name=meteord-test-app
base_app_image_name="${base_app_name}-image"

trap "echo Failed: Meteor app" EXIT

# doalarm 5 sleep 10

clean() {
  docker rm -f "${base_app_name}" 2> /dev/null || true
  docker rmi -f "${base_app_image_name}" 2> /dev/null || true
  rm -rf ${base_app_name} || true
}

cd /tmp
clean

look_for="==== METEORDTEST ===="

meteor create "${base_app_name}"
cd "${base_app_name}"
echo "FROM abernix/meteord:base" > Dockerfile

add_server_lookfor

test_root_url_hostname=yourapp_dot_com

docker build -t "${base_app_image_name}" ./
docker run -d \
    --name "${base_app_name}" \
    -e ROOT_URL=http://$test_root_url_hostname \
    -p 8080:80 \
    "${base_app_image_name}"

watch_docker_logs_for "${base_app_name}" "${look_for}" || true
sleep 1

check_server_for "8080" "${test_root_url_hostname}" || true

clean
trap - EXIT
