#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/kafka/dev/${version}/cloudformation/kafka-broker-clustered.cf.json"

# Parameters 

# Common Zookeepr 
environment="dit"
vpcStackName="mobile-dev-vpc"
kafkaCommonStackName="kafka-common-dit"
clusterName="kafka"
enableSsh="yes"
devopsBucket="wex-mobile-devops"
instanceKeyPair="mwd-devops"
amiId="ami-e6bd9f9c"
instanceType="t3.large"
kafkaInfrastructureVersion="dev/${version}"
ansibleRoleVersion="dev/2.0.0_20180425-233807"
logVolumeSize=100
deploymentId="asdjlkajsdslkjasdlk"

# Instance
kafkaBrokerId=1
instanceAz="A"
kafkaBootstrapServer="yes"
dnsName="kafka-bootstrap-2.dit.intwexmobile.net"

stackName="kafka-broker-${clusterName}-${kafkaBrokerId}-${environment}"

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
  ParameterKey=logVolumeSize,ParameterValue=${logVolumeSize} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  ParameterKey=kafkaBrokerId,ParameterValue=${kafkaBrokerId} \
  ParameterKey=instanceAz,ParameterValue=${instanceAz} \
  ParameterKey=kafkaBootstrapServer,ParameterValue=${kafkaBootstrapServer} \
  ParameterKey=dnsName,ParameterValue=${dnsName} \
  --output text --profile mobile-dev

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
  ParameterKey=logVolumeSize,ParameterValue=${logVolumeSize} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  ParameterKey=kafkaBrokerId,ParameterValue=${kafkaBrokerId} \
  ParameterKey=instanceAz,ParameterValue=${instanceAz} \
  ParameterKey=kafkaBootstrapServer,ParameterValue=${kafkaBootstrapServer} \
  ParameterKey=dnsName,ParameterValue=${dnsName} \
  --output text --profile mobile-dev

fi 
