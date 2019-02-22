#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/mobile-gateway/releases/${version}/cloudformation/smarthub-service.cf.json"

# parameters
environment="prod"
vpcStackName="mobile-prod-vpc"
kafkaStackName="kafka-common-prod"
albCommonStackName="mg-alb-prod"
rdsSecurityGroupId="sg-3849aa4f"
enableSsh="no"
amiId="ami-e0bd9f9a"
instanceType="t3.large"
instanceKeyPair="mwd-devops"
desiredCapacity=2
maxCount=4
minCount=2
asgUpdateBatchSize=1
hostedZoneId="Z3V6XCD1LK11OS"
dnsName="smarthub-service.wexmobileauth.com"
ansibleRoleVersion="releases/2.3.0"
projectVersion="releases/${version}"
appVersion="1.0.0-release"
deploymentId="23sdfsdvsddfsdfsddff03"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name smarthub-service-prod --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kafkaStackName,ParameterValue=${kafkaStackName} \
  ParameterKey=albCommonStackName,ParameterValue=${albCommonStackName} \
  ParameterKey=rdsSecurityGroupId,ParameterValue=${rdsSecurityGroupId} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=desiredCapacity,ParameterValue=${desiredCapacity} \
  ParameterKey=maxCount,ParameterValue=${maxCount} \
  ParameterKey=minCount,ParameterValue=${minCount} \
  ParameterKey=asgUpdateBatchSize,ParameterValue=${asgUpdateBatchSize} \
  ParameterKey=hostedZoneId,ParameterValue=${hostedZoneId} \
  ParameterKey=dnsName,ParameterValue=${dnsName} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=projectVersion,ParameterValue=${projectVersion} \
  ParameterKey=appVersion,ParameterValue=${appVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-prod

else

  aws cloudformation update-stack --region us-east-1 --stack-name smarthub-service-prod --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kafkaStackName,ParameterValue=${kafkaStackName} \
  ParameterKey=albCommonStackName,ParameterValue=${albCommonStackName} \
  ParameterKey=rdsSecurityGroupId,ParameterValue=${rdsSecurityGroupId} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=desiredCapacity,ParameterValue=${desiredCapacity} \
  ParameterKey=maxCount,ParameterValue=${maxCount} \
  ParameterKey=minCount,ParameterValue=${minCount} \
  ParameterKey=asgUpdateBatchSize,ParameterValue=${asgUpdateBatchSize} \
  ParameterKey=hostedZoneId,ParameterValue=${hostedZoneId} \
  ParameterKey=dnsName,ParameterValue=${dnsName} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=projectVersion,ParameterValue=${projectVersion} \
  ParameterKey=appVersion,ParameterValue=${appVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-prod

fi
