#!/bin/bash

set -e

IMAGE_NAME="hemanth10bh1010/dev:latest"
CONTAINER_NAME="devops-build-app"

echo "Stopping old container if it exists..."
docker rm -f $CONTAINER_NAME 2>/dev/null || true

echo "Pulling latest image..."
docker pull $IMAGE_NAME

echo "Running new container on port 80..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 80:80 \
  --restart unless-stopped \
  $IMAGE_NAME

echo "Deployment successful."
docker ps
