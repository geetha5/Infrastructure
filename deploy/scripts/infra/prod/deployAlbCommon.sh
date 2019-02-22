#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/mobile-gateway/releases/${version}/cloudformation/alb-common.cf.json"

# parameters
environment="prod"
vpcStackName="mobile-prod-vpc"
externalClientAcmCertArn="arn:aws:acm:us-east-1:032744083734:certificate/88bf63bd-e9fe-4e1e-9b4f-fe806123ddee"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name mg-alb-prod --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=externalClientAcmCertArn,ParameterValue=${externalClientAcmCertArn} \
  --output text --profile mobile-prod 

else 

  aws cloudformation update-stack --region us-east-1 --stack-name mg-alb-prod --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=externalClientAcmCertArn,ParameterValue=${externalClientAcmCertArn} \
  --output text --profile mobile-prod 

fi