#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/salesforce-app/releases/${version}/cloudformation/salesforce-backend.cf.json"

# parameters
environment="prod"
vpcStackName="mobile-prod-vpc"
dbStackName="none"
rdsSecurityGroup="sg-0eda42944a6b6b29c"
acmCertArn="arn:aws:acm:us-east-1:032744083734:certificate/92cc7359-813a-4b51-a64f-87ed9fc11884"
enableSsh="yes"
devopsBucket="wex-mobile-devops"
instanceKeyPair="mwd-devops"
amiId="ami-e0bd9f9a"
instanceType="t3.large"
desiredCapacity=2
maxCount=2
minCount=0
devMode="no"
asgUpdateBatchSize=1
hostedZoneId="Z28UA6A3XCHJDE"
dnsSuffix="wexfleetcards.com"
appVersion="1.0.4"
ansibleRoleVersion="releases/2.4.0"
projectVersion="releases/${version}"
deploymentId="dosjsdsdfsdffdfsdf"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name salesforce-app-prod --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=dbStackName,ParameterValue=${dbStackName} \
  ParameterKey=rdsSecurityGroup,ParameterValue=${rdsSecurityGroup} \
  ParameterKey=acmCertArn,ParameterValue=${acmCertArn} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=devMode,ParameterValue=${devMode} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=desiredCapacity,ParameterValue=${desiredCapacity} \
  ParameterKey=maxCount,ParameterValue=${maxCount} \
  ParameterKey=minCount,ParameterValue=${minCount} \
  ParameterKey=asgUpdateBatchSize,ParameterValue=${asgUpdateBatchSize} \
  ParameterKey=hostedZoneId,ParameterValue=${hostedZoneId} \
  ParameterKey=dnsSuffix,ParameterValue=${dnsSuffix} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=projectVersion,ParameterValue=${projectVersion} \
  ParameterKey=appVersion,ParameterValue=${appVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-prod
else

  aws cloudformation update-stack --region us-east-1 --stack-name salesforce-app-prod --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=dbStackName,ParameterValue=${dbStackName} \
  ParameterKey=rdsSecurityGroup,ParameterValue=${rdsSecurityGroup} \
  ParameterKey=acmCertArn,ParameterValue=${acmCertArn} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=devMode,ParameterValue=${devMode} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=desiredCapacity,ParameterValue=${desiredCapacity} \
  ParameterKey=maxCount,ParameterValue=${maxCount} \
  ParameterKey=minCount,ParameterValue=${minCount} \
  ParameterKey=asgUpdateBatchSize,ParameterValue=${asgUpdateBatchSize} \
  ParameterKey=hostedZoneId,ParameterValue=${hostedZoneId} \
  ParameterKey=dnsSuffix,ParameterValue=${dnsSuffix} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=projectVersion,ParameterValue=${projectVersion} \
  ParameterKey=appVersion,ParameterValue=${appVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-prod
fi
