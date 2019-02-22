#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/kafka/releases/${version}/cloudformation/zookeeper-clustered.cf.json"

# Parameters 

# Common Zookeepr 
environment="prod"
vpcStackName="mobile-prod-vpc"
kafkaCommonStackName="kafka-common-prod"
clusterName="kafka"
enableSsh="no"
devopsBucket="wex-mobile-devops"
instanceKeyPair="mwd-devops"
amiId="ami-e0bd9f9a"
instanceType="t3.large"
kafkaInfrastructureVersion="releases/${version}"
ansibleRoleVersion="releases/2.3.0"
deploymentId="asdjlkajsdslkjasdlk"
asgActionLambdaStackName="none"

# Instance
zookeeperInstanceNumber=2
instanceAz="B"

stackName="zookeeper-${clusterName}-${zookeeperInstanceNumber}-${environment}"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name ${stackName} --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kafkaCommonStackName,ParameterValue=${kafkaCommonStackName} \
  ParameterKey=clusterName,ParameterValue=${clusterName} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=kafkaInfrastructureVersion,ParameterValue=${kafkaInfrastructureVersion} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  ParameterKey=asgActionLambdaStackName,ParameterValue=${asgActionLambdaStackName} \
  ParameterKey=zookeeperInstanceNumber,ParameterValue=${zookeeperInstanceNumber} \
  ParameterKey=instanceAz,ParameterValue=${instanceAz} \
  --output text --profile mobile-prod

else 

  aws cloudformation update-stack --region us-east-1 --stack-name ${stackName} --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kafkaCommonStackName,ParameterValue=${kafkaCommonStackName} \
  ParameterKey=clusterName,ParameterValue=${clusterName} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=kafkaInfrastructureVersion,ParameterValue=${kafkaInfrastructureVersion} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  ParameterKey=asgActionLambdaStackName,ParameterValue=${asgActionLambdaStackName} \
  ParameterKey=zookeeperInstanceNumber,ParameterValue=${zookeeperInstanceNumber} \
  ParameterKey=instanceAz,ParameterValue=${instanceAz} \
  --output text --profile mobile-prod

fi 
