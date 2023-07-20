
Implementation of real-world application: https://github.com/gothinkster/realworld/ using Django and HTMX.

An in-depth discussion of this implementation can be found [here](https://danjacob.net/posts/anatomyofdjangohtmxproject/).

# Test Container application locally

## Prerequisites

Docker: Ensure you have Docker installed and running. You can download Docker from the official website: https://www.docker.com/get-started

## Getting Started

Follow the steps below to set up and test the containerized application:
1. Clone the respository:

```bash
git clone https://github.com/shamnaar/django-htmx-app.git
cd django-htmx-app
```
2. Build the docker image
```docker build -t my-django-app```
3. Run the container
```docker run -d -p 8000:8000 my-django-app```
4. Access the Application: Open your web browser and navigate to http://localhost:8000. 
5. Test the application
6. Stop the Container: Once you've finished testing, you can stop the container using its container ID or name.
```bash
docker ps
docker stop <container_id_or_name>
```

# GitHub Actions CI/CD Workflow for deployment on AWS

!["Deploy on ECS"](assets/ecs.jpg?raw=true)

## Prerequisites

- AWS Account: You need an AWS account to use ECS and related services.

- OIDC Identity Provider: Set up an OIDC identity provider for your GitHub Actions workflow to authenticate with AWS. https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

- In your GitHub repository settings, navigate to "Secrets" and add the following secrets:
*AWS_ROLE_ARN*: Update the assume role arn as secret.

## Deploying Infrastructure on AWS

You can manually trigger the GitHub Actions pipeline to deploy the necessary AWS infrastructure for your Docker application on ECS. This automated approach simplifies the process of setting up and managing your AWS resources, making it easier to deploy and scale your Docker application with minimal effort.
This pipeline will create VPC, ECR, ECS, ALB, Security Group, Autoscaling on AWS that are required for deploying the docker application on ECS.

### Run Workflow

Select the workflow "Terraform AWS infrastructure" and click "Run workflow", then select which branch, action "apply" to deploy the infrastructure, then choose "ecs_deployment". Run Workflow.

## Deploying Dockerized App on ECS

After the infrastructure is created, you can trigger this pipeline to build and push the Docker image to ECR. The pipeline will automatically be triggered on every push to the `main` branch. Once the image is pushed to ECR, ECS will fetch it and run the containers, allowing you to access the application through the load balancer URL.

## Possible Enhancement

For future expansion, optimize the infrastructure by transitioning from Amazon Elastic Container Service (ECS) to Amazon Elastic Kubernetes Service (EKS) for better management and scaling of our Docker applications. We can also introduce Amazon CloudWatch for comprehensive performance monitoring, and use Amazon S3 and DynamoDB for Terraform remote backend, to enhance security and availability.

If application requires a database, implement Amazon Relational Database Service (RDS). These improvements demonstrate our dedication to creating a flexible, scalable infrastructure that evolves with our expanding needs, guaranteeing the best performance and user experience.

