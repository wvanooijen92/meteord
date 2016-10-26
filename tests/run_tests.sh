#!/bin/sh
set -e

: ${NODE_VERSION?"NODE_VERSION has not been set."}

my_dir=`dirname $0`
root_dir="$my_dir/.."

${root_dir}/build_it.sh

for meteor_version in `cat ${my_dir}/meteor_versions_to_test`; do
  ${my_dir}/test_meteor_app.sh "${meteor_version}"
done

${my_dir}/test_bundle_local_mount.sh

# This uses BUNDLE_URL from S3
${my_dir}/test_bundle_web.sh

${my_dir}/test_phantomjs.sh
${my_dir}/test_no_app.sh
