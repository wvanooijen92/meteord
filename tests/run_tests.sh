#!/bin/sh

set -e
set -x

: ${NODE_VERSION?"NODE_VERSION has not been set."}

./build_it.sh

./test_meteor_app.sh

./test_bundle_local_mount.sh

# This uses BUNDLE_URL from S3
./test_bundle_web.sh

./test_phantomjs.sh
./test_no_app.sh
