#!/bin/bash

NAME=$1
COUNT=$2

STACK_NAME="${NAME}"

FARGATE_CLUSTER=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[].Outputs[?OutputKey==`FargateCluster`].OutputValue' --output text)

COUNT=$(aws ecs list-tasks --cluster $FARGATE_CLUSTER --family $STACK_NAME --query "taskArns[]" --output text | wc -l)
while [ $COUNT -ne 1 ]; do
  #echo "Actual task count $COUNT <> expected cout 1. Sleeping 30s"
  sleep 30
  COUNT=$(aws ecs list-tasks --cluster $FARGATE_CLUSTER --family $STACK_NAME --query "taskArns[]" --output text | wc -l)
done

TASK_ARN=$(aws ecs list-tasks --cluster $FARGATE_CLUSTER --family $STACK_NAME --query "taskArns[]" --output text)

NETWORK_INTERFACE_ID=$(aws ecs describe-tasks --tasks "$TASK_ARN" --cluster $FARGATE_CLUSTER --query 'tasks[].attachments[].details[?name==`networkInterfaceId`].value' --output text)

PUBLIC_IP=$(aws ec2 describe-network-interfaces --query "NetworkInterfaces[?NetworkInterfaceId==\`$NETWORK_INTERFACE_ID\`].Association.PublicIp" --output text)

echo $PUBLIC_IP
