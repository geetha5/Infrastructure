#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/auth-map/releases/${version}/cloudformation/auth-map.cf.json"

# parameters
environment="prod"
vpcStackName="mobile-prod-vpc"
kafkaStackName="kafka-common-prod"
enableSsh="no"
amiId="ami-e0bd9f9a"
instanceType="t3.large"
instanceKeyPair="mwd-devops"
desiredCapacity=2
maxCount=4
minCount=2
asgUpdateBatchSize=1
hostedZoneId="Z3V6XCD1LK11OS"
acmCertArn="arn:aws:acm:us-east-1:032744083734:certificate/88bf63bd-e9fe-4e1e-9b4f-fe806123ddee"
dnsName="auth-map.wexmobileauth.com"
ansibleRoleVersion="releases/2.3.0"
projectVersion="releases/${version}"
appVersion="1.2.0-release"
deploymentId="2388ssdfsdfsfsasdasd8398403f9sdf"


if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name auth-map-prod --template-url ${templateUrl} \
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
  ParameterKey=hostedZoneId,ParameterValue=${hostedZoneId} \
  ParameterKey=acmCertArn,ParameterValue=${acmCertArn} \
  ParameterKey=dnsName,ParameterValue=${dnsName} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=projectVersion,ParameterValue=${projectVersion} \
  ParameterKey=appVersion,ParameterValue=${appVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-prod

else

  aws cloudformation update-stack --region us-east-1 --stack-name auth-map-prod --template-url ${templateUrl} \
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
  ParameterKey=hostedZoneId,ParameterValue=${hostedZoneId} \
  ParameterKey=acmCertArn,ParameterValue=${acmCertArn} \
  ParameterKey=dnsName,ParameterValue=${dnsName} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=projectVersion,ParameterValue=${projectVersion} \
  ParameterKey=appVersion,ParameterValue=${appVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-prod

fi
