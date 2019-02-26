#!/bin/bash

NAME=$1
COUNT=$2

STACK_NAME="${NAME}"

BUCKET1=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[].Outputs[?OutputKey==`CodeBuildCacheBucket`].OutputValue' --output text)
aws s3 rm s3://$BUCKET1/ --recursive

BUCKET2=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[].Outputs[?OutputKey==`PipelineArtifsctStoreBucket`].OutputValue' --output text)
aws s3 rm s3://$BUCKET2/ --recursive

aws ecr delete-repository --repository-name $STACK_NAME --force

aws cloudformation delete-stack --stack-name "${NAME}Code"

aws cloudformation delete-stack --stack-name "${NAME}"
