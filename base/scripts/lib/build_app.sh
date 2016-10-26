#!/bin/sh

set -e # Exit on any bad exit status
set -x # Print each command

# Shouldn't matter, but just in case.
export METEOR_NO_RELEASE_CHECK=1

# Because of CDN issues.
: ${METEOR_WAREHOUSE_URLBASE:="https://d3fm2vapipm3k9.cloudfront.net"}
export METEOR_WAREHOUSE_URLBASE

copied_app_path=/copied-app
bundle_dir=/tmp/bundle-dir

echo "=> Current environment"
export

# sometimes, directly copied folder cause some weird issues
# this fixes that
echo "=> Copying the app"
cp -R /app $copied_app_path
cd $copied_app_path

ls -la

cver () {
  echo $1 | perl -n \
  -e '@ver = /^(?:[^\@]+\@)?([0-9]+)\.([0-9]+)(?:\.([0-9]+))?(?:\.([0-9]+))?/;' \
  -e 'printf "%04s%04s%04s%04s", @ver;'
}

if ! [ -d ".meteor" ]; then
  echo "*** There is no '.meteor' directory in this project!"
  exit 1
fi

if ! [ -f ".meteor/release" ]; then
  echo "There is no .meteor/release file on this project."
  echo "Make sure the project is configured properly."
  exit 1
fi

echo "=> App Meteor Version"
meteor_version_app=$(cat .meteor/release)
echo "  > $meteor_version_app"
if [ $(cver "$meteor_version_app") -ge $(cver "1.4.2") ]; then
  unsafe_perm_flag="--unsafe-perm"
else
  unsafe_perm_flag=""
fi

echo "=> Executing NPM install --production"
meteor npm install --production

echo "=> Executing Meteor Build..."

METEOR_LOG=debug \
  meteor build \
  ${unsafe_perm_flag} \
  --directory $bundle_dir \
  --server=http://localhost:3000

# echo "=> Printing Meteor Node information..."
# echo "  => platform"
# meteor node -p process.platform
# echo "  => arch"
# meteor node -p process.arch
# echo "  => versions"
# meteor node -p process.versions

# echo "=> Printing System Node information..."
# echo "  => platform"
# node -p process.platform
# echo "  => arch"
# node -p process.arch
# echo "  => versions"
# node -p process.versions

echo "=> Executing NPM install within Bundle"
(cd ${bundle_dir}/bundle/programs/server/ && npm install --unsafe-perm)

echo "=> Moving bundle"
mv ${bundle_dir}/bundle /built_app

echo "=> Cleaning up"
# cleanup
echo " => copied_app_path"
rm -rf $copied_app_path
echo " => bundle_dir"
rm -rf ${bundle_dir}
echo " => .meteor"
rm -rf ~/.meteor
rm /usr/local/bin/meteor