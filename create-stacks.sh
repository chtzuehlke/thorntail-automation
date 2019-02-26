#!/bin/bash

PROJECT_NAME=${1:-test}

echo "Creating git repo"

echo ./create-stack-gitrepo.sh $PROJECT_NAME
./create-stack-gitrepo.sh $PROJECT_NAME

echo "Waiting for CloudFormation stack: ${PROJECT_NAME}Code"

aws cloudformation wait stack-create-complete --stack-name "${PROJECT_NAME}Code"

export REPO_SSH_URL=$(./describe-stack-gitrepo-url.sh $PROJECT_NAME)

echo "Pushing demo project to git repo: $REPO_SSH_URL"

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

echo "Creating CI/CD pipeline, Fargate cluster, et al"

echo ./create-stack-fargate-ci-cd.sh $PROJECT_NAME
./create-stack-fargate-ci-cd.sh $PROJECT_NAME

echo "Waiting for CloudFormation stack: ${PROJECT_NAME}"

aws cloudformation wait stack-create-complete --stack-name $PROJECT_NAME

echo "Wait until build pipeline has been executed for the first time (service version increase after successful deployment to ECS)"

./ecs_wait_for_task_definition_version.sh $PROJECT_NAME 2

echo "Starting container with demo app (increasing desired count from 0 to 1)"

./ecs_update_service_desiredcount.sh $PROJECT_NAME 1

echo "Wait for public IP of newly created container"

PUBLIC_IP=$(./ecs_container_ip.sh $PROJECT_NAME)

echo
echo "Soon you can reach your HTTP endpoint:"
echo curl -v http://$PUBLIC_IP:8080/catalog?search=foox

echo
echo "Pushes from projects/$PROJECT_NAME will trigger the CI/CD pipeline"

echo
echo "Stop the container after experimenting:"
echo ./ecs_update_service_desiredcount.sh $PROJECT_NAME 1
