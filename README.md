# Infastructure for AWS ECS
### Prerequisites
- AWS account with programatic access
- [AWS CLI](https://aws.amazon.com/cli/) must be installed
- Domain name in Route 53 (talentize.com is my example)  

## What's Created: AWS ECS Fargate Infrastructure
![API Infastructure](https://www.aaronwht.com/images/fargate/fargate-nginx.png)  

You'll need to locate your VPC and two subnets. 

This code creates the infrastructure for an API service using AWS ECS Fargate and deploys a default NGINX container.  Once successful the sub-domain and SSL cert are attached to the ALB, then deploy the image.


`ecs-1.yml` creates the AWS ECS Fargate infastructure for an API service.  
`ecs-2.yml` updates the infrastructure to use HTTPS and the sub-domain. 

Have you VPC ID handy along with two subnet ID's and run the below snippet:  
```aws cloudformation create-stack --stack-name aws-ecs-typescript-api --template-body file://./ecs-1.yml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=Subnet1ID,ParameterValue=subnet-XXXXXXXX ParameterKey=Subnet2ID,ParameterValue=subnet-XXXXXXXX ParameterKey=VPCID,ParameterValue=XXXXXXXX ParameterKey=DomainName,ParameterValue=domainname.com```

After the stack has been created succesfully run the below snippent including the same VPC ID's and subnets.  
```aws cloudformation update-stack --stack-name aws-ecs-typescript-api --template-body file://./ecs-2.yml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=Subnet1ID,ParameterValue=subnet-XXXXXXXX ParameterKey=Subnet2ID,ParameterValue=subnet-XXXXXXXX ParameterKey=VPCID,ParameterValue=XXXXXXXX ParameterKey=DomainName,ParameterValue=domainname.com```

 



# Containerized TypeScript App for AWS ECS

`npm i`  
`npm run dev` 

`deploy-to-ecr.sh` provides instructions to push Docker Image to ECR

Run application locally use the below commands:  
`npm i`  
`npm run dev` 

Then open http://localhost in your browser.  