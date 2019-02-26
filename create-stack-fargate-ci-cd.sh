#!/bin/bash

NAME=$1
REPO_STACK_NAME="${NAME}Code"
STACK_NAME="${NAME}"

CODE_COMMIT_ARN=$(aws cloudformation describe-stacks --stack-name $REPO_STACK_NAME --query 'Stacks[].Outputs[?OutputKey==`CodeCommitRepositoryARN`].OutputValue' --output text)
CODE_COMMIT_NAME=$(aws cloudformation describe-stacks --stack-name $REPO_STACK_NAME --query 'Stacks[].Outputs[?OutputKey==`CodeCommitRepositoryName`].OutputValue' --output text)

DEFAULT_VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[?IsDefault==`true`].VpcId' --output text)
SUBNET_IDS=$(aws ec2 describe-subnets --query "Subnets[?VpcId==\`$DEFAULT_VPC_ID\`].SubnetId" --output text | sed 's/[[:space:]]/,/g')

aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://./fargate-ci-cd.yaml --capabilities CAPABILITY_IAM --parameters \
    ParameterKey=CodeCommitRepositoryARN,ParameterValue="$CODE_COMMIT_ARN" \
    ParameterKey=CodeCommitRepositoryName,ParameterValue="$CODE_COMMIT_NAME" \
    ParameterKey=Subnets,ParameterValue=\"$SUBNET_IDS\" \
    ParameterKey=VPC,ParameterValue=$DEFAULT_VPC_ID
