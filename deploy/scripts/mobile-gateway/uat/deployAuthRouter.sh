#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/mobile-gateway/dev/${version}/cloudformation/auth-router.cf.json"

# parameters
environment="stage"
vpcStackName="mobile-stage-vpc"
kafkaStackName="kafka-common-stage"
enableSsh="yes"
amiId="ami-e1bd9f9b"
instanceType="t3.large"
instanceKeyPair="mwd-devops"
desiredCapacity=2
maxCount=4
minCount=2
asgUpdateBatchSize=1
ansibleRoleVersion="dev/2.2.0_20180726-173928"
projectVersion="dev/${version}"
appVersion="1.0.1-latest"
deploymentId="2sdfssdskddfdfjsdfsd403f9sdf"


if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name auth-router-stage --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kafkaStackName,ParameterValue=${kafkaStackName} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=desiredCapacity,ParameterValue=${desiredCapacity} \
  ParameterKey=maxCount,ParameterValue=${maxCount} \
  ParameterKey=minCount,ParameterValue=${minCount} \
  ParameterKey=asgUpdateBatchSize,ParameterValue=${asgUpdateBatchSize} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=projectVersion,ParameterValue=${projectVersion} \
  ParameterKey=appVersion,ParameterValue=${appVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-stage

else

  aws cloudformation update-stack --region us-east-1 --stack-name auth-router-stage --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kafkaStackName,ParameterValue=${kafkaStackName} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=desiredCapacity,ParameterValue=${desiredCapacity} \
  ParameterKey=maxCount,ParameterValue=${maxCount} \
  ParameterKey=minCount,ParameterValue=${minCount} \
  ParameterKey=asgUpdateBatchSize,ParameterValue=${asgUpdateBatchSize} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=projectVersion,ParameterValue=${projectVersion} \
  ParameterKey=appVersion,ParameterValue=${appVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-stage

fi
