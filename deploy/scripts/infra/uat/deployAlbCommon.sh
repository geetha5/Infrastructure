#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/mobile-gateway/dev/${version}/cloudformation/alb-common.cf.json"

# parameters
environment="stage"
vpcStackName="mobile-stage-vpc"
elbLogStackName="elb-logging-stage"
externalClientAcmCertArn="arn:aws:acm:us-east-1:784360110492:certificate/dd6b1088-6e63-4178-84ea-cfda9a25e72c"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name mg-alb-stage --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=elbLogStackName,ParameterValue=${elbLogStackName} \
  ParameterKey=externalClientAcmCertArn,ParameterValue=${externalClientAcmCertArn} \
  --output text --profile mobile-stage 

else 

  aws cloudformation update-stack --region us-east-1 --stack-name mg-alb-stage --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=elbLogStackName,ParameterValue=${elbLogStackName} \
  ParameterKey=externalClientAcmCertArn,ParameterValue=${externalClientAcmCertArn} \
  --output text --profile mobile-stage 

fi