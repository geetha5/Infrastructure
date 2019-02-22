#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/kafka/dev/${version}/cloudformation/kafka-common.cf.json"

# parameters
environment="stage"
vpcStackName="mobile-stage-vpc"
clusterName="kafka"
enableSsh="yes"
devopsBucket="wex-mobile-devops"
environmentDevopsBucket="mwd-devops"
hostedZoneId="ZFJP39NGUEQPR"

stackName="kafka-common-stage"

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
  --output text --profile mobile-stage

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
  --output text --profile mobile-stage

fi
