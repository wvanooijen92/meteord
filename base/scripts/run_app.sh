#!/bin/sh

set -e
my_dir=`dirname $0`
path=`pwd`

if [ -d /bundle ]; then
  cd /bundle
  tar xzf *.tar.gz
  cd /bundle/bundle/programs/server/
  npm install --unsafe-perm
  cd /bundle/bundle/
elif [ -n "$BUNDLE_URL" ]; then
  cd /tmp
  curl -L -o bundle.tar.gz $BUNDLE_URL
  tar xzf bundle.tar.gz
  cd /tmp/bundle/programs/server/
  npm install --unsafe-perm
  cd /tmp/bundle/
elif [ -d /built_app ]; then
  cd /built_app
else
  echo "=> You don't have an meteor app to run in this image."
  exit 1
fi

echo "=> Bundle Version"
BUNDLE_METEOR_VERSION="$(node ${path}/${my_dir}/lib/get_bundle_version)"
echo " > ${BUNDLE_METEOR_VERSION}"

echo "=> Proper Node Version"
PROPER_NODE_VERSION="$(node ${path}/${my_dir}/lib/meteor_to_node_version)"
echo " > ${PROPER_NODE_VERSION}"

echo "=> Actual Node Version"
ACTUAL_NODE_VERSION="$(node --version | sed 's/^v//')"
echo " > ${ACTUAL_NODE_VERSION}"

# Set a delay to wait to start meteor container
if [ -n "$DELAY" ]; then
  echo "Delaying startup for $DELAY seconds"
  sleep $DELAY
fi

# Honour already existing PORT setup
export PORT=${PORT:-80}

echo "=> Starting meteor app on port:$PORT"
node main.js
