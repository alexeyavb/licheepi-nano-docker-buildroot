#!/bin/bash
export BUILDKIT_COLORS="run=blue:error=red:cancel=yellow:warning=blue"
export BUILDKIT_TTY_LOG_LINES=40

DOCKER_ID="armbian_build:set"
TARGET="toolchain_prepare"
echo $UID
echo $USER

docker build  --build-arg UID=$UID --build-arg USERNAME=$USER \
    -t $DOCKER_ID \
    --target $TARGET \
    -f Dockerfile.base \
    .
