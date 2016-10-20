#!/bin/sh

set -e

if [ -d "$HOME/.meteor" ]; then
  echo "Meteor Home directory already exists!"
fi
curl -sL https://install.meteor.com | sed s/--progress-bar/-sL/g | /bin/sh
