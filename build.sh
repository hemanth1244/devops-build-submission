#!/bin/bash

set -e

APP_NAME="devops-build"
DEV_IMAGE="hemanth10bh1010/dev:latest"
PROD_IMAGE="hemanth10bh1010/prod:latest"

echo "Building Docker image for DEV..."
docker build -t $DEV_IMAGE .

echo "Tagging image for PROD..."
docker tag $DEV_IMAGE $PROD_IMAGE

echo "Build completed successfully."
docker images | grep hemanth10bh1010
