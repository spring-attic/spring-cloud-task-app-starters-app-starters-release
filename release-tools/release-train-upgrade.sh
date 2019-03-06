#!/bin/bash

# The script takes two arguments - release version and app starters core parent version.

if [ "$#" -ne 2 ]; then
    echo "Please specify the release version, app starters core parent version"
    exit
fi

pushd /tmp

git clone git@github.com:spring-cloud-task-app-starters/app-starters-release.git
cd app-starters-release

./mvnw versions:set -DnewVersion=$1 -DgenerateBackupPoms=false
./mvnw versions:update-parent -DparentVersion=$2 -Pspring -DgenerateBackupPoms=false

git commit -am"Update version to $1"
git push origin master

cd ..
rm -rf app-starters-release

popd
