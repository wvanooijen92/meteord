#!/bin/bash
set -x

: ${NODE_VERSION?"NODE_VERSION has not been set."}

docker build --build-arg "NODE_VERSION=${NODE_VERSION}" -t "wvanooijen92/meteord:node-${NODE_VERSION}-base" ../base && \
  docker tag "wvanooijen92/meteord:node-${NODE_VERSION}-base" wvanooijen92/meteord:base
docker build --build-arg "NODE_VERSION=${NODE_VERSION}" -t "wvanooijen92/meteord:node-${NODE_VERSION}-onbuild" ../onbuild && \
  docker tag "wvanooijen92/meteord:node-${NODE_VERSION}-onbuild" wvanooijen92/meteord:onbuild
docker build --build-arg "NODE_VERSION=${NODE_VERSION}" -t "wvanooijen92/meteord:node-${NODE_VERSION}-devbuild" ../devbuild && \
  docker tag "wvanooijen92/meteord:node-${NODE_VERSION}-devbuild" wvanooijen92/meteord:devbuild
docker build --build-arg "NODE_VERSION=${NODE_VERSION}" -t "wvanooijen92/meteord:node-${NODE_VERSION}-binbuild" ../binbuild && \
  docker tag "wvanooijen92/meteord:node-${NODE_VERSION}-binbuild" wvanooijen92/meteord:binbuild
