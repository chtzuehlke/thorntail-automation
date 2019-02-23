#!/bin/bash

NAME=$1
STACK_NAME="${NAME}Code"

aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://./gitrepo.yaml --capabilities CAPABILITY_IAM
