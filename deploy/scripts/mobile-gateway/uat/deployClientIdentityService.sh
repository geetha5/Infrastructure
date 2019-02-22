#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/mobile-gateway/dev/${version}/cloudformation/clientidentity-service.cf.json"

# parameters
environment="stage"
vpcStackName="mobile-stage-vpc"
albCommonStackName="mg-alb-stage"
rdsSecurityGroupId="sg-5c356c28"
enableSsh="yes"
amiId="ami-e1bd9f9b"
instanceType="t3.large"
instanceKeyPair="mwd-devops"
desiredCapacity=2
maxCount=4
minCount=2
asgUpdateBatchSize=1
hostedZoneId="Z3FRC7D0BUOWIE"
dnsName="client-identity-service.stage.wexmobileauth.com"
ansibleRoleVersion="dev/2.2.0_20180726-173928"
projectVersion="dev/${version}"
appVersion="1.0.1-latest"
deploymentId="238adssjsasasdjdslsdflfjjddjfksjdlfjfdflsjlfjf03"
deploymentId=$(date | md5)

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name clientidentity-service-stage --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
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
  --output text --profile mobile-stage

else

  aws cloudformation update-stack --region us-east-1 --stack-name clientidentity-service-stage --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
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
  --output text --profile mobile-stage

fi
