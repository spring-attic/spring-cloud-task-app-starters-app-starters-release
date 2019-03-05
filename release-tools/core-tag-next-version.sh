#!/bin/bash
# The script takes two arguments -  currently released version for tagging and next version

if [ "$#" -ne 2 ]; then
    echo "Please specify the released version and the next version"
    exit
fi

git clone git@github.com:spring-cloud-task-app-starters/core.git
cd core

git tag v$1
git push origin v$1

./mvnw versions:set -DnewVersion=$2 -DgenerateBackupPoms=false
./mvnw versions:set -DnewVersion=$2 -DgenerateBackupPoms=false -pl :task-app-starters-core-dependencies

sed -i '' 's/<task-app-starters-core-dependencies.version>.*/<task-app-starters-core-dependencies.version>'"$2"'<\/task-app-starters-core-dependencies.version>/g' pom.xml

git commit -am"Next version - $2"
git push origin master

cd ..
rm -rf core
