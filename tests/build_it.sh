#!/bin/sh

set -x

: ${NODE_VERSION?"NODE_VERSION has not been set."}

docker build --build-arg "NODE_VERSION=${NODE_VERSION}" -t "abernix/meteord:base-node-${NODE_VERSION}" ../base && \
  docker tag "abernix/meteord:base-node-${NODE_VERSION}" abernix/meteord:base
docker build --build-arg "NODE_VERSION=${NODE_VERSION}" -t "abernix/meteord:onbuild-node-${NODE_VERSION}" ../onbuild && \
  docker tag "abernix/meteord:onbuild-node-${NODE_VERSION}" abernix/meteord:onbuild
