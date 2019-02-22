#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/kafka/dev/${version}/cloudformation/kafka-common.cf.json"

# parameters
environment="dit"
vpcStackName="mobile-dev-vpc"
clusterName="kafka"
enableSsh="yes"
devopsBucket="wex-mobile-devops"
environmentDevopsBucket="wex-mobile-devops-dev"
hostedZoneId="ZI82C9E3PIYU"

stackName="kafka-common-dit"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name ${stackName} --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=clusterName,ParameterValue=${clusterName} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=environmentDevopsBucket,ParameterValue=${environmentDevopsBucket} \
  ParameterKey=hostedZoneId,ParameterValue=${hostedZoneId} \
  --output text --profile mobile-dev

else

  aws cloudformation update-stack --region us-east-1 --stack-name ${stackName} --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=clusterName,ParameterValue=${clusterName} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=environmentDevopsBucket,ParameterValue=${environmentDevopsBucket} \
  ParameterKey=hostedZoneId,ParameterValue=${hostedZoneId} \
  --output text --profile mobile-dev

fi