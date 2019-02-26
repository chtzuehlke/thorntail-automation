#!/bin/bash

PROJECT_NAME=${1:-test}

./create-stack-gitrepo.sh $PROJECT_NAME
aws cloudformation wait stack-create-complete --stack-name "${PROJECT_NAME}Code"

export REPO_SSH_URL=$(./describe-stack-gitrepo-url.sh $PROJECT_NAME)

mkdir -p projects
git clone https://github.com/chtzuehlke/thorntail-codebuild-hello-world.git projects/$PROJECT_NAME

cd projects/$PROJECT_NAME
rm -fR .git
git init
git add .
git commit -m "first commit"
git remote add origin $REPO_SSH_URL
git push -u origin master
cd ../../

./create-stack-fargate-ci-cd.sh $PROJECT_NAME
aws cloudformation wait stack-create-complete --stack-name "${PROJECT_NAME}"

echo "Adjust service's desired count as follows:"
echo "./ecs_update_service_desiredcount.sh $PROJECT_NAME <count>"
