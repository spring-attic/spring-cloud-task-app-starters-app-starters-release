#!/bin/bash

# The script takes three arguments -  currently released version for tagging, next update version and parent (core)update version.

if [ "$#" -ne 3 ]; then
    echo "Please specify the released version, next version, next snapshot version for core"
    exit
fi

pushd /tmp

git clone git@github.com:spring-cloud-task-app-starters/app-starters-release.git
cd app-starters-release

 git tag v$1
 git push origin v$1

 ./mvnw versions:set -DnewVersion=$2 -DgenerateBackupPoms=false
 ./mvnw versions:update-parent -DparentVersion=$3 -Pspring -DgenerateBackupPoms=false -DallowSnapshots=true

 git commit -am"Next version: $2"
 git push origin master

 cd ..
rm -rf app-starters-release

popd
