#!/bin/bash -e
DOCKER_ID="armbian_build:set"
docker run --ipc=host  -it --rm \
  -l "${USER}_axr" \
  -v ${PWD}/:/home/${USER}/from_host_mapped \
  ${DOCKER_ID} \
  /bin/bash
