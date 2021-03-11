# AWS ECS Fargate - TypeScript App

[Correlating Video Tutorial](https://youtu.be/eaS1jza_hy0)  
### Prerequisites
- AWS account with programatic access
- [AWS CLI](https://aws.amazon.com/cli/) must be installed
- Domain name in Route 53 ([talentize.com](https://www.talentize.com) is my example)  

## Creates an AWS ECS Fargate Infrastructure
![API Infastructure](https://www.aaronwht.com/images/fargate/fargate-nginx.png)  

### Running this App locally
`npm i`  
`npm run dev`  
Then open http://localhost in your browser.   

### What you'll need to deploy to AWS:  
A VPC and two subnets in the same AWS Region. 

The code in this repository creates the infrastructure for an API service using AWS ECS Fargate and initially uses the default NGINX Image.  Once successfully running, the sub-domain and SSL cert are attached to the ALB.  You may then create an Image for this application locally, push it to AWS ECR and update the AWS ECS Fargate service to use your Image.  

`ecs-1.yml` creates the AWS ECS Fargate infastructure for the API service.  
`ecs-2.yml` updates the infrastructure to use HTTPS and the sub-domain.  
Further instructions demonstrate pushing this application to AWS ECR and deploying to AWS.  

Have your VPC ID handy along with two subnet ID's and run the below snippet replacing the four variables:
- YOUR_VPC_ID
- YOUR_SUBNET_1_ID
- YOUR_SUBNET_2_ID
- YOUR_DOMAIN_NAME.com  

## STEP 1

```aws cloudformation create-stack --stack-name aws-ecs-typescript-api --template-body file://./ecs-1.yml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=VPCID,ParameterValue=YOUR_VPC_ID ParameterKey=Subnet1ID,ParameterValue=YOUR_SUBNET_1_ID ParameterKey=Subnet2ID,ParameterValue=YOUR_SUBNET_2_ID  ParameterKey=DomainName,ParameterValue=YOUR_DOMAIN_NAME.com```  

After the stack has been succesfully created, run the below snippent replacing the same VPC ID's and subnets as above:  

## STEP 2
```aws cloudformation update-stack --stack-name aws-ecs-typescript-api --template-body file://./ecs-2.yml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=Subnet1ID,ParameterValue=YOUR_SUBNET_1_ID ParameterKey=Subnet2ID,ParameterValue=YOUR_SUBNET_2_ID ParameterKey=VPCID,ParameterValue=YOUR_VPC_ID ParameterKey=DomainName,ParameterValue=YOUR_DOMAIN_NAME.com```

## Create an Image of this App and push to AWS ECR  
Use your Account Number and Region and run the below snippet replacing instances of the variables:
- YOUR_AWS_ACCCOUNT_NUMBER 
- YOUR_AWS_REGION  
```
docker build -t aws-ecs-typescript-api .  

docker tag aws-ecs-typescript-api:latest YOUR_AWS_ACCCOUNT_NUMBER.dkr.ecr.YOUR_AWS_REGION.amazonaws.com/aws-ecs-typescript-api:latest  

aws ecr get-login-password --region YOUR_AWS_REGION | docker login --username AWS --password-stdin YOUR_AWS_ACCOUNT_NUMBER.dkr.ecr.YOUR_AWS_REGION.amazonaws.com  

docker push YOUR_AWS_ACCOUNT_NUMBER.dkr.ecr.YOUR_AWS_REGION.amazonaws.com/aws-ecs-typescript-api:latest
```  

## IMPORTANT
Replace the reference to `Image:` in `ecs-2.yml`  
YOU MUST replace YOUR_AWS_ACCOUNT_NUMBER and YOUR_AWS_REGION to use your Image:    
![API Infastructure](https://www.aaronwht.com/images/fargate/aws-ecr-001.png)  
with:
![API Infastructure](https://www.aaronwht.com/images/fargate/aws-ecr-002.png)  

Save `ecs-2.yml` and re-run the script from STEP 2.