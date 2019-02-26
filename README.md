# thorntail-automation with CloudFormation (alpha version)

## Intro

Q: Quick way to start a new thorntail-based (https://thorntail.io/) and AWS Fargate-backed (https://aws.amazon.com/fargate/) project?

A: This step by step guide shows you how to create the following in approx. 5':

CloudFormation (https://aws.amazon.com/cloudformation/) stack 1:
- New CodeCommit (https://aws.amazon.com/codecommit/) git repository for your new JEE demo app

CloudFormation stack 2:
- New ECR Repository (docker repository) for your new JEE demo app container
- Your app deployed to a newly created Fargate Cluster (as a service with desired count=0 and one task with one container with your app)
- New CI/CD pipeline (push adjusted app sources and your app will be re-reployed) leveraging CodePipeline and CodeBuild

Disclainer: Not tested/ready for production (yet) => read and understand the scripts & templates before executing them!

## FIXMEs

- Update Route53 managed CNAME after re-deploy (avoid expensive ALB)

## Pre-conditions

- Linux-like environment: Bash, curl, git, sed, ...
- AWS CLI installed and configured (IAM user with ~admin permissions)
- Setup Steps for SSH Connections to AWS CodeCommit Repositories: https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-ssh-unixes.html?icmpid=docs_acc_console_connect_np

## Step by step (short version)

    ./create-stack-fargate-ci-cd.sh hellee
