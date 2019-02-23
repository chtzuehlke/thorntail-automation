#!/bin/bash

NAME=$1
STACK_NAME="${NAME}Code"

aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[].Outputs[?OutputKey==`CodeCommitRepositoryCloneURL`].OutputValue' --output text
