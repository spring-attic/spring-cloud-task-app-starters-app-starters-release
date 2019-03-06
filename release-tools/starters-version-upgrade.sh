#!/bin/bash

# The script takes three arguments - release version, app starters core parent version, BOM parent version (spring-cloud-build-dependencies) 

if [ "$#" -ne 3 ]; then
    echo "Please specify the release version, app starters core parent version, BOM parent version"
    exit
fi

ARRAY=(
        "timestamp:spring-cloud-task-app-starters/timestamp.git"
        "timestamp-batch:spring-cloud-task-app-starters/timestamp-batch.git"
        )

for repo in "${ARRAY[@]}" ; do
 KEY="${repo%%:*}"
 VALUE="${repo##*:}"

 git clone git@github.com:$VALUE

 cd $KEY

 # BOM parent update
 ./mvnw versions:update-parent "-DparentVersion=[0.0.1,$3]" -Pspring -DgenerateBackupPoms=false -pl $KEY-task-app-dependencies

 ./mvnw versions:set -DnewVersion=$1 -DgenerateBackupPoms=false
 ./mvnw versions:set -DnewVersion=$1 -DgenerateBackupPoms=false -pl :$KEY-task-app-dependencies
 ./mvnw versions:update-parent -DparentVersion=$2 -Pspring -DgenerateBackupPoms=false -pl \!$KEY-task-app-dependencies

snapshotlines=$(find . -type f -name pom.xml | xargs grep SNAPSHOT | wc -l)
rclines=$(find . -type f -name pom.xml | xargs grep .RC | wc -l)
milestonelines=$(find . -type f -name pom.xml | xargs grep version | grep .M | wc -l)

if [ $snapshotlines -eq 0 ] && [ $rclines -eq 0 ] && [$milestonelines -eq 0 ]; then
        echo "All clear"
	git commit -am"Update version to $1"
        git push origin master
else
  	echo "Snapshots found."
        echo "SNAPSHOTS: " $snapshotlines
        echo "Milestones: " $milestonelines
        echo "RC: " $rclines
        exit 1
fi

 cd ..

 rm -rf $KEY
 printf "%s repo removed locally" "$KEY"

done
