#!/bin/sh

set -x
set -e

: ${NODE_VERSION?"NODE_VERSION has not been set."}

my_dir=`dirname $0`
root_dir="$my_dir/.."

if [ -z $CIRCLE_NODE_TOTAL ] || [ -z "${CIRCLE_NODE_INDEX}" ]; then
  echo "Not running on CircleCI"
  exit 1
fi

our_meteor_versions=$(
    cat ${my_dir}/meteor_versions_to_test | \
      awk "NR % ${CIRCLE_NODE_TOTAL} == ${CIRCLE_NODE_INDEX}"
  )

if ! [ -z "$testfiles" ]; then
  echo "more parallelism than tests"
  exit 0
fi

for meteor_version in `echo $our_meteor_versions`; do
  ${my_dir}/test_meteor_app.sh "${meteor_version}"
done
