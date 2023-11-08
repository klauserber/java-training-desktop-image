#!/usr/bin/env bash

REGISTRY_NAME=isi006
IMAGE_NAME=java-training-desktop

docker push \
    ${REGISTRY_NAME}/${IMAGE_NAME}:latest
