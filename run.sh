#!/usr/bin/env sh

REGISTRY_NAME=isi006
IMAGE_NAME=java-training-desktop

docker run -it -p 6901:6901 --cap-add=SYS_ADMIN --shm-size 1gb \
  ${REGISTRY_NAME}/${IMAGE_NAME}:latest $@
