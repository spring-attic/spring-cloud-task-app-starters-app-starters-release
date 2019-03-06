#!/bin/bash

# The script takes thress arguments -  currently released version for tagging, next version, next version for core 

if [ "$#" -ne 3 ]; then
    echo "Please specify the released version, next version, next snapshot version for core"
    exit
fi

ARRAY=(
        "composed-task-runner:spring-cloud-task-app-starters/composed-task-runner.git"
        )

for repo in "${ARRAY[@]}" ; do
 KEY="${repo%%:*}"
 VALUE="${repo##*:}"

 git clone git@github.com:$VALUE

 cd $KEY

 git tag v$1
 git push origin v$1
 ./mvnw versions:set -DnewVersion=$2 -DgenerateBackupPoms=false
 ./mvnw versions:set -DnewVersion=$2 -DgenerateBackupPoms=false -pl :composedtaskrunner-task-app-dependencies
 ./mvnw versions:update-parent -DparentVersion=[0.0.1,$3] -Pspring -DgenerateBackupPoms=false -DallowSnapshots=true -pl \!composedtaskrunner-task-app-dependencies

 git commit -am"Next version - $2"
 git push origin master

 cd ..

 rm -rf $KEY
 printf "%s repo removed locally" "$KEY"
 sleep 3

done
