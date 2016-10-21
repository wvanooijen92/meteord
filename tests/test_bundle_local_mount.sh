#!/bin/sh

set -x
set -e

base_app_name=meteord-test-localmount

trap "echo Failed: Bundle local mount" EXIT

clean() {
  docker rm -f "${base_app_name}" 2> /dev/null || true
  rm -rf meteord-test-localmount || true
}

cd /tmp
clean

meteor create "${base_app_name}"
cd "${base_app_name}"
meteor build --architecture=os.linux.x86_64 ./

test_root_url_hostname=yourapp_dot_com

docker run -d \
    --name "${base_app_name}" \
    -e ROOT_URL=http://$test_root_url_hostname \
    -v "/tmp/${base_app_name}:/bundle" \
    -p 9090:80 \
    "abernix/meteord:base"

sleep 50

appContent=`curl http://localhost:9090`
clean

trap - EXIT

if test '"'${appContent#*"localmount_app"}'"' != "$appContent"; then
  echo "Failed: Bundle local mount"
  exit 1
fi