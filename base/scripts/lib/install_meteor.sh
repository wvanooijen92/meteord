#!/bin/sh

set -e
export

if [ -d "$HOME/.meteor" ]; then
  echo "Meteor Home directory already exists!"
else
  echo "Meteor Home directory does not exist."
  curl -sL https://install.meteor.com | sed s/--progress-bar/-sL/g | /bin/sh
fi

METEOR_SYMLINK_TARGET="$(readlink "$HOME/.meteor/meteor")"
METEOR_TOOL_DIRECTORY="$(dirname "$METEOR_SYMLINK_TARGET")"
LAUNCHER="$HOME/.meteor/$METEOR_TOOL_DIRECTORY/scripts/admin/launch-meteor"
echo "Making 'meteor' Symlink from ${LAUNCHER}"
ln $LAUNCHER -sf /usr/local/bin/meteor