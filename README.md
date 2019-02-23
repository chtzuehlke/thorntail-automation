# thorntail-automation with CloudFormation

Pre-conditions

- bash (tested with Terminal.app)
- AWS CLI installed configured (IAM user with admin permissions)
- Setup Steps for SSH Connections to AWS CodeCommit Repositories: https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-ssh-unixes.html?icmpid=docs_acc_console_connect_np

Create new CodeCommit git repository

    ./create-stack-gitrepo.sh hellee

Create a thorntail (JEE) hello world application and push to your newly created git repository

    export REPO_SSH_URL=$(./describe-stack-gitrepo-url.sh hellee)
    
    git clone https://github.com/chtzuehlke/thorntail-codebuild-hello-world.git
    cd thorntail-codebuild-hello-world/
    rm -fR .git

    git init
    git add .
    git commit -m "First commit"
    git status
    git remote add origin $REPO_SSH_URL
    git push -u origin master

Create CI/CD pipeline

    ./create-stack-fargate-ci-cd.sh hellee

Test your deployed thorntail (JEE) app

    #FIXME figure out IP yourself ;-)
    curl -v  34.244.43.137:8080/catalog?search=foo

Modify and test your re-deployed function

    vi ./src/main/java/com/zuehlke/cht/poc/catalogpicsearch/rest/CatalogEndpoint.java
    git commit -a -m "adjusted"
    git push

    sleep FIXME

    curl FIXME

Done :)
