#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/kafka/releases/${version}/cloudformation/kafka-common.cf.json"

# parameters
environment="prod"
vpcStackName="mobile-prod-vpc"
clusterName="kafka"
enableSsh="yes"
devopsBucket="wex-mobile-devops"
environmentDevopsBucket="wex-mobile-devops-prod"
hostedZoneId="Z2G0W5QEU5ZVQY"

stackName="kafka-common-prod"

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
  --output text --profile mobile-prod

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
  --output text --profile mobile-prod

fi