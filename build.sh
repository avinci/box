#!/bin/bash -e

export BRANCH=master
export IMAGE_NAME=avinci/box
export IMAGE_TAG=$BRANCH.$BUILD_NUMBER
export RES_DOCKER_CREDS=docker-creds
export RES_BOX_REPO=box-repo
export RES_BOX_IMAGE=box-img

dockerBuild() {
  echo "Starting Docker build for" $IMAGE_NAME:$IMAGE_TAG
  cd ./IN/$RES_BOX_REPO/gitRepo
  sudo docker build -t=$IMAGE_NAME:$IMAGE_TAG .
  echo "Completed Docker build for" $IMAGE_NAME:$IMAGE_TAG
}

dockerPush() {
  echo "Starting Docker push for" $IMAGE_NAME:$IMAGE_TAG
  sudo docker push $IMAGE_NAME:$IMAGE_TAG
  echo "Completed Docker push for" $IMAGE_NAME:$IMAGE_TAG
}

dockerLogin() {
  echo "Extracting docker creds"
  . ./IN/$RES_DOCKER_CREDS/integration.env
  echo "logging into Docker with username" $username
  docker login -u $username -p $password -e $email
  echo "Completed Docker login"
}

createOutState() {
  echo "Creating a state file for" $RES_BOX_IMAGE
  echo versionName=$IMAGE_TAG > /build/state/$RES_BOX_IMAGE.env
  cat /build/state/$RES_BOX_IMAGE.env
  echo "Completed creating a state file for" $RES_BOX_IMAGE
}

main() {
  dockerLogin
  dockerBuild
  dockerPush
  createOutState
}

main
