# thorntail-automation with CloudFormation (alpha version)

## Intro

Q: Quick way to start a new thorntail-based (https://thorntail.io/) and AWS Fargate-backed (https://aws.amazon.com/fargate/) project?

A: This step by step guide shows you how to create the following in approx. 15':

CloudFormation (https://aws.amazon.com/cloudformation/) stack 1:
- New CodeCommit (https://aws.amazon.com/codecommit/) git repository for your new JEE demo app

CloudFormation stack 2:
- New ECR Repository (docker repository) for your new JEE demo app container
- Your app deployed to a newly created Fargate Cluster (as a service with desired count=0 and one task with one container with your app)
- New CI/CD pipeline (push adjusted app sources and your app will be re-reployed) leveraging CodePipeline and CodeBuild

Disclainer: Not tested/ready for production (yet).

## FIXMEs

- Update Route53 managed CNAME after re-deploy (avoid expensive ALB)

## Pre-conditions

- Linux-like environment: Bash, curl, git, sed, ...
- AWS CLI installed and configured (IAM user with ~admin permissions)
- Setup Steps for SSH Connections to AWS CodeCommit Repositories: https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-ssh-unixes.html?icmpid=docs_acc_console_connect_np

## Step by step

Create new CodeCommit git repository for a new sample app called "hellee"

    ./create-stack-gitrepo.sh hellee

Create a thorntail (JEE) hello world application and push to your newly created git repository

    export REPO_SSH_URL=$(./describe-stack-gitrepo-url.sh hellee)
    
    git clone https://github.com/chtzuehlke/thorntail-codebuild-hello-world.git
    cd thorntail-codebuild-hello-world/
    
    rm -fR .git
    git init
    git add .
    git commit -m "First commit"
    git remote add origin $REPO_SSH_URL
    git push -u origin master

    cd ..

Create CI/CD pipeline

    ./create-stack-fargate-ci-cd.sh hellee

    #FIXME wait for first successful build ;-)

    ./ecs_update_service_desiredcount.sh hellee 1

Test your deployed thorntail (JEE) app

    #FIXME figure out IP yourself ;-)

    curl -v  34.242.197.81:8080/catalog?search=foo

Modify and test your re-deployed function

    cd thorntail-codebuild-hello-world/

    vi ./src/main/java/com/zuehlke/cht/poc/catalogpicsearch/rest/CatalogEndpoint.java
    git commit -a -m "adjusted"
    git push

    cd ..

    #FIXME wait for 2nd successful build ;-)
    #FIXME figure out _new_ IP yourself ;-)

    curl -v  52.213.77.222:8080/catalog?search=foo

Save costs (you're still paying)

    ./ecs_update_service_desiredcount.sh hellee 0

Done :)
