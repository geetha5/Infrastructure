#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/mobile-gateway/releases/${version}/cloudformation/analytic-service.cf.json"

# parameters
environment="prod"
vpcStackName="mobile-prod-vpc"
snsStackName="analytic-service-sns-prod"
rdsSecurityGroupId="sg-3849aa4f"
enableSsh="no"
amiId="ami-e0bd9f9a"
instanceType="t3.large"
instanceKeyPair="mwd-devops"
ansibleRoleVersion="releases/2.3.0"
projectVersion="releases/${version}"
appVersion="1.1.0-release"
deploymentId="2388301aslsdjajdkajsdjafljaldjfald03f9sdf"


if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name analytic-service-prod --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=snsStackName,ParameterValue=${snsStackName} \
  ParameterKey=rdsSecurityGroupId,ParameterValue=${rdsSecurityGroupId} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=projectVersion,ParameterValue=${projectVersion} \
  ParameterKey=appVersion,ParameterValue=${appVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-prod

else

  aws cloudformation update-stack --region us-east-1 --stack-name analytic-service-prod --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=snsStackName,ParameterValue=${snsStackName} \
  ParameterKey=rdsSecurityGroupId,ParameterValue=${rdsSecurityGroupId} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=projectVersion,ParameterValue=${projectVersion} \
  ParameterKey=appVersion,ParameterValue=${appVersion} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-prod

fi
