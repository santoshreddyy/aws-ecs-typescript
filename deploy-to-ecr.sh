docker build -t aws-ecs-typescript-api .
docker tag aws-ecs-typescript-api:latest XXXXXXXXXXXX.dkr.ecr.YOUR-REGION.amazonaws.com/aws-ecs-typescript-api:latest
aws ecr get-login-password --region YOUR-REGION | docker login --username AWS --password-stdin XXXXXXXXXXXX.dkr.ecr.YOUR-REGION.amazonaws.com
docker push XXXXXXXXXXXX.dkr.ecr.YOUR-REGION.amazonaws.com/aws-ecs-typescript-api:latest
aws ecs update-service --cluster service-api --service aws-ecs-typescript-api --force-new-deployment