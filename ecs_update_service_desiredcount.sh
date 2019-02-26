#!/bin/bash

NAME=$1
COUNT=$2

STACK_NAME="${NAME}"

FARGATE_CLUSTER=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[].Outputs[?OutputKey==`FargateCluster`].OutputValue' --output text)

aws ecs update-service --cluster $FARGATE_CLUSTER --service $NAME --desired-count $COUNT
