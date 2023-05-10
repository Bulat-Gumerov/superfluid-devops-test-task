# Superfluid DevOps Engineer Test Task

## Task Description
Superfluid Sentinel is a piece of software designed to protect the Superfluid network from insolvency events using the solvency mechanism of the protocol. Read more about it at: Running a Sentinel

Your task is to create a Terraform-based GitHub Actions workflow that can continuously deploy the Sentinel to your own AWS ECS for Polygon mainnet for each commit to GitHub. We will create a Telegram support channel for any questions you have come up with!
We want to respect your time so we at most expect you to put in a couple of hours.
[Optional] If you know Nix or want to learn Nix, convert the Sentinel's Dockerfile to using Nix. That'd be grand!

## Requirements
- Docker
- Terraform
- AWS account
- GitHub account
- Docker Hub account

## How to run
- Clone or fork this repo
- Create a new AWS user with programmatic access and AdministratorAccess policy
- Create a new AWS profile with the credentials of the user you just created
- Create a new GitHub secret called AWS_ACCESS_KEY_ID with the access key ID of the user you just created
- Create a new GitHub secret called AWS_SECRET_ACCESS_KEY with the secret access key of the user you just created
- Create a new GitHub secret called AWS_REGION with the region you want to deploy to
- Create a new GitHub secret called DOCKERHUB_USERNAME with your Docker Hub username
- Create a new GitHub secret called DOCKER_HUB_ACCESS_TOKEN with your Docker Hub access token
- Create a new GitHub secret called TELEGRAM_CI_CHANNEL with the Telegram channel build failures you want to send notifications to

Create the AWS ECS cluster and service with terraform:
```terraform plan -var-file="example.tfvars"```
```terraform apply -var-file="example.tfvars"```

Go to the AWS ECS console and check that the service is running. Then create a task definition using [AWS Console](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-task-definition.html). Save [the JSON file](https://console.aws.amazon.com/ecs/v2) to the root of the project and name it task-definition.json. Commit the changes and push them to GitHub. The GitHub Actions workflow will be triggered and the service will be updated.

## Other optimizations
[Original Docker image](https://github.com/superfluid-finance/superfluid-sentinel/blob/master/Dockerfile) from the superfluid-sentinel repo could be optimized by:
- Using a smaller base image: The node:16-alpine image is a good choice for a lightweight container, but an even smaller base image like node:16-alpine3.17 could be used to reduce the overall size of the container from 814 MB(i.e. latest version 0.10 ) to ~40 MB.
- Combining multiple RUN commands: The RUN commands that create the data directory and change ownership to node could be combined into a single command to reduce the number of layers in the image.
- Use multi-stage builds: Multi-stage builds can be used to create a smaller final image by using a build stage to install dependencies and a production stage to copy only the dependencies and the built application into the final image.
- Nix won't help in this case, because it is just a yet another package manager, and it is not a good idea to use multiple package managers in one project.
- Apple switched from x86_64 architecture to ARM64, and it is a good idea to do the same. Try to build the image for ARM64 architecture, because it is more efficient than x86_64, and it is supported by AWS ECS. This will allow to use smaller instances, and reduce the cost of running the service in the cloud. For example, the Amazon t4g.nano instance costs $0.0042 per hour, while the t3.nano instance costs $0.0052 per hour.
Another issue is that there's some outdated dependencies [in the package.json](https://github.com/superfluid-finance/superfluid-sentinel/blob/master/package.json) file, which could be updated to the latest versions.
