#!/bin/sh

set -x
set -e

: ${NODE_VERSION?"must be set."}
: ${IMAGE_NAME:=abernix/spaceglue}
: ${IMAGE_TAG:=base}

DOCKER_IMAGE_NAME_BASE="${IMAGE_NAME}:node-${NODE_VERSION}"
DOCKER_IMAGE_NAME_BUILDDEPS="${DOCKER_IMAGE_NAME_BASE}-builddeps"
DOCKER_IMAGE_NAME_ONBUILD="${DOCKER_IMAGE_NAME_BASE}-onbuild"

if [ -z "$FINAL_BUILD" ]; then
  test_build_hash="-$(date | (md5sum || md5) | head -c10)"

  DOCKER_IMAGE_NAME_BASE="${DOCKER_IMAGE_NAME_BASE}${test_build_hash}"
  DOCKER_IMAGE_NAME_BUILDDEPS="${DOCKER_IMAGE_NAME_BUILDDEPS}${test_build_hash}"
  DOCKER_IMAGE_NAME_ONBUILD="${DOCKER_IMAGE_NAME_ONBUILD}${test_build_hash}"
fi

my_dir=`dirname $0`
root_dir="$my_dir/.."

# Run as a subshell to avoid polluting `my_dir` up.
(

  build_image_derivative () {
    derivative=$1
    derivative_tag=$2

    derivative_dockerfile="${root_dir}/images/${derivative}/Dockerfile.from.$(
      echo ${DOCKER_IMAGE_NAME_BASE} | tr '/:' '_'
    )"

    cleanup_derivative () {
      rm -f "${derivative_dockerfile}"
    }

    trap "cleanup_derivative && echo Failed: Could not build '${derivative}' image" EXIT

    sed "s|^FROM .*$|FROM ${DOCKER_IMAGE_NAME_BASE}|" \
      "${root_dir}/images/${derivative}/Dockerfile" > \
      "${derivative_dockerfile}"

    docker build \
        -t "${derivative_tag}" \
        -f "${derivative_dockerfile}" \
        "${root_dir}/images/${derivative}"

    trap - EXIT
    cleanup_derivative

  }

  docker build \
      -t "${DOCKER_IMAGE_NAME_BASE}" \
      ${root_dir}/images/base

  build_image_derivative builddeps $DOCKER_IMAGE_NAME_BUILDDEPS
  build_image_derivative onbuild $DOCKER_IMAGE_NAME_ONBUILD

)

set +x
set +e
