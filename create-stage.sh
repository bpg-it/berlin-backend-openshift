#!/bin/bash
set -euxo pipefail

# adjust stage name here
STAGE_NAME=dev

# project which will be created
TARGET_NAMESPACE=bpgit-berlin-$STAGE_NAME

# where to pull images from?
IMAGE_NAMESPACE=bpgit-berlin-builder

# specify image tag (develop, latest, ...)
IMAGE_TAG=latest

# set spring profile (optional)
SPRING_PROFILES_ACTIVE=default

oc new-project $TARGET_NAMESPACE

oc process -o yaml -f ./builder/builder-rolebinding.yml -l environment=$STAGE_NAME -p STAGE_NAMESPACE=$TARGET_NAMESPACE | oc apply -f - --namespace=$IMAGE_NAMESPACE

oc process -o yaml -f ./stage/stage-pvc.yml -l environment=$STAGE_NAME | oc apply -f - --namespace=$TARGET_NAMESPACE

oc process -o yaml -f ./stage/stage-routes.yml -l environment=$STAGE_NAME -p STAGE_NAME=$STAGE_NAME | oc apply -f - --namespace=$TARGET_NAMESPACE

oc process -o yaml -f ./stage/stage-secrets.yml -l environment=$STAGE_NAME | oc apply -f - --namespace=$TARGET_NAMESPACE

oc process -o yaml -f ./stage/stage-services.yml -l environment=$STAGE_NAME | oc apply -f - --namespace=$TARGET_NAMESPACE

oc process -o yaml -f ./stage/stage-deploymentconfig.yml -l environment=$STAGE_NAME -p IMAGE_NAMESPACE=$IMAGE_NAMESPACE -p SPRING_PROFILES_ACTIVE=$SPRING_PROFILES_ACTIVE -p IMAGE_TAG=$IMAGE_TAG -p NAMESPACE_FOR_ROUTE=$TARGET_NAMESPACE | oc apply -f - --namespace=$TARGET_NAMESPACE

echo "Startup in progress. You may delete your project at anytime using the following commmand:"
echo "oc delete project $TARGET_NAMESPACE"
