#!/bin/sh

set -e
set -x

COPIED_APP_PATH=/copied-app
BUNDLE_DIR=/tmp/bundle-dir

echo "=> Current environment"
export

get_meteor_version() {
  echo $(meteor --version | tr -d '\r')
}

echo "=> System Meteor Version"
METEOR_VERSION_SYSTEM=$(get_meteor_version)
echo "  > $METEOR_VERSION_SYSTEM"

# sometimes, directly copied folder cause some wierd issues
# this fixes that
echo "=> Copying the app"
cp -R /app $COPIED_APP_PATH
cd $COPIED_APP_PATH

cver () {
  echo $1 | perl -n \
  -e '@ver = /([0-9]+)\.([0-9]+)(?:\.([0-9]+))?(?:\.([0-9]+))?/;' \
  -e 'printf "%04s%04s%04s%04s", @ver;'
}

echo "=> App Meteor Version"
METEOR_VERSION_APP=$(get_meteor_version)
if [ $(cver "$MET_OUTPUT") -ge $(cver "1.4.2") ]; then
  UNSAFE_PERM_FLAG="--unsafe-perm"
else
  UNSAFE_PERM_FLAG=""
fi

echo "=> Executing NPM install --production"
meteor npm install --production

echo "=> Executing Meteor Build..."

METEOR_WAREHOUSE_URLBASE=https://d3fm2vapipm3k9.cloudfront.net \
  METEOR_LOG=debug \
  meteor build \
  ${UNSAFE_PERM_FLAG} \
  --directory $BUNDLE_DIR \
  --server=http://localhost:3000

echo "=> Printing Meteor Node information..."
echo "  => platform"
meteor node -p process.platform
echo "  => arch"
meteor node -p process.arch
echo "  => versions"
meteor node -p process.versions

echo "=> Printing System Node information..."
echo "  => platform"
node -p process.platform
echo "  => arch"
node -p process.arch
echo "  => versions"
node -p process.versions

echo "=> Executing NPM install within Bundle"
cd $BUNDLE_DIR/bundle/programs/server/
npm i

echo "=> Moving bundle"
mv $BUNDLE_DIR/bundle /built_app

echo "=> Cleaning up"
# cleanup
echo " => COPIED_APP_PATH"
rm -rf $COPIED_APP_PATH
echo " => BUNDLE_DIR"
rm -rf $BUNDLE_DIR
echo " => .meteor"
rm -rf ~/.meteor
rm /usr/local/bin/meteor