#!/bin/bash

set -x

docker build --no-cache -t abernix/meteord:base-node-4.4.7 ../base
docker build --no-cache -t abernix/meteord:onbuild-node-4.4.7 ../onbuild
docker build --no-cache -t abernix/meteord:devbuild-node-4.4.7 ../devbuild
docker build --no-cache -t abernix/meteord:binbuild-node-4.4.7 ../binbuild
