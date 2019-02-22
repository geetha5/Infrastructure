#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/kafka/dev/${version}/cloudformation/zookeeper-clustered.cf.json"

# Parameters 

# Common Zookeepr 
environment="dit"
vpcStackName="mobile-dev-vpc"
kafkaCommonStackName="kafka-common-dit"
asgActionLambdaStackName="asg-action-lambda-dev"
clusterName="kafka"
enableSsh="yes"
devopsBucket="wex-mobile-devops"
instanceKeyPair="mwd-devops"
amiId="ami-e6bd9f9c"
instanceType="t3.large"
kafkaInfrastructureVersion="dev/${version}"
ansibleRoleVersion="dev/2.1.0_20180706-130028"
deploymentId="asdjlkadsdkfjssksdfsdfsdlk"

# Instance
zookeeperInstanceNumber=1
instanceAz="A"

stackName="zookeeper-${clusterName}-${zookeeperInstanceNumber}-${environment}"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name ${stackName} --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kafkaCommonStackName,ParameterValue=${kafkaCommonStackName} \
  ParameterKey=asgActionLambdaStackName,ParameterValue=${asgActionLambdaStackName} \
  ParameterKey=clusterName,ParameterValue=${clusterName} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=kafkaInfrastructureVersion,ParameterValue=${kafkaInfrastructureVersion} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  ParameterKey=zookeeperInstanceNumber,ParameterValue=${zookeeperInstanceNumber} \
  ParameterKey=instanceAz,ParameterValue=${instanceAz} \
  --output text --profile mobile-dev

else 

  aws cloudformation update-stack --region us-east-1 --stack-name ${stackName} --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kafkaCommonStackName,ParameterValue=${kafkaCommonStackName} \
  ParameterKey=asgActionLambdaStackName,ParameterValue=${asgActionLambdaStackName} \
  ParameterKey=clusterName,ParameterValue=${clusterName} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=kafkaInfrastructureVersion,ParameterValue=${kafkaInfrastructureVersion} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  ParameterKey=zookeeperInstanceNumber,ParameterValue=${zookeeperInstanceNumber} \
  ParameterKey=instanceAz,ParameterValue=${instanceAz} \
  --output text --profile mobile-dev

fi 
