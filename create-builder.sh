#!/bin/bash
set -euxo pipefail

# where to build images?
BUILDER_NAMESPACE=bpgit-berlin-builder

oc new-project $BUILDER_NAMESPACE

# create jenkins with storage first
oc new-app jenkins-persistent
oc scale --replicas=0 --timeout=1m dc/jenkins

# modify resource limits
oc set resources dc/jenkins --limits=memory=1024Mi
oc rollout latest dc/jenkins
oc rollout status -w dc/jenkins

# now start jenkins
oc scale --replicas=1 --timeout=1m dc/jenkins

# start first build immediately 
oc new-build https://github.com/bpg-it/berlin-backend-jenkins.git

echo "Startup and build in progress. You may delete your builder project at anytime using the following commmand:"
echo "oc delete project $BUILDER_NAMESPACE"
