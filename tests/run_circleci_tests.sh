#!/bin/sh

set -x
set -e

: ${NODE_VERSION?"NODE_VERSION has not been set."}

my_dir=`dirname $0`
root_dir="$my_dir/.."

if [ -z "${CIRCLE_NODE_TOTAL}" ] || [ -z "${CIRCLE_NODE_INDEX}" ]; then
  echo "Not running on CircleCI"
  exit 1
fi

our_normal_scripts="
${my_dir}/test_meteor_app.sh
${my_dir}/test_meteor_versions.sh
${my_dir}/test_bundle_local_mount.sh
${my_dir}/test_bundle_web.sh
${my_dir}/test_phantomjs.sh
${my_dir}/test_no_app.sh
"

our_version_scripts=$(
    cat ${my_dir}/meteor_versions_to_test | \
      xargs -n1 -I% echo ${my_dir}/test_meteor_app.sh %
  )

if ! [ -z "$testfiles" ]; then
  echo "more parallelism than tests"
  exit 0
fi

our_workload=$(echo "${our_normal_scripts} ${our_version_scripts}" |\
  awk "NR % ${CIRCLE_NODE_TOTAL} == ${CIRCLE_NODE_INDEX}")

IFS=$'\n'
for test_script in $our_workload; do
  sh ${test_script}
done
