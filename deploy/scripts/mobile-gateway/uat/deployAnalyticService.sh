#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/mobile-gateway/dev/${version}/cloudformation/analytic-service.cf.json"

# parameters
environment="stage"
vpcStackName="mobile-stage-vpc"
snsStackName="analytic-service-sns-stage"
rdsSecurityGroupId="sg-5c356c28"
enableSsh="yes"
amiId="ami-e1bd9f9b"
instanceType="t3.large"
instanceKeyPair="mwd-devops"
ansibleRoleVersion="dev/2.2.0_20180726-173928"
projectVersion="dev/${version}"
appVersion="1.1.0-release"
deploymentId="2388301asldjlkajsdjkhfs8398403f9sdf"


if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name analytic-service-stage --template-url ${templateUrl} \
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
  --output text --profile mobile-stage

else

  aws cloudformation update-stack --region us-east-1 --stack-name analytic-service-stage --template-url ${templateUrl} \
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
  --output text --profile mobile-stage

fi
