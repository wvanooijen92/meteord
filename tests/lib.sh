#!/bin/sh

echo "Testing shit"

doalarm () { perl -e 'alarm shift; exec @ARGV' "$@"; }

add_server_lookfor () {
  cat <<EOM > server/main.js
    require('meteor/meteor').Meteor.startup(() => console.log('$look_for'));
EOM
}

watch_docker_logs_for () {
  doalarm ${3:-60} sh -c \
    'docker logs -f "$1" | grep --line-buffered -m1 "$2"'
}

check_server_for () {
  curl -s "http://localhost:$1" | grep "${2}" 2>&1 > /dev/null
}