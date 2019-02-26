#!/bin/bash

NAME=$1
STACK_NAME="${NAME}"

aws ecs describe-task-definition --task-definition $STACK_NAME --query "taskDefinition.revision"
