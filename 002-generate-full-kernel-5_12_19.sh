#!/bin/bash
export BUILDKIT_COLORS="run=blue:error=red:cancel=yellow:warning=blue"
export BUILDKIT_TTY_LOG_LINES=40

DOCKER_ID="armbian_build:set"
TARGET="dist"
echo $UID
echo $USER

docker build  --build-arg UID=$UID --build-arg USERNAME=$USER \
    -t $DOCKER_ID \
    --target $TARGET \
    -f Dockerfile.base \
    --output type=tar,dest=- . | (mkdir -p dist && tar x -C dist)
