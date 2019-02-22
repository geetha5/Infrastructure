#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/mobile-gateway/releases/${version}/cloudformation/site-integration-service.template"

# parameters
environment="prod"
vpcStackName="mobile-prod-vpc"
kafkaStackName="mg-kafka-prod"
rdsSecurityGroupId="sg-3849aa4f"
enableSsh="no"
amiId="ami-e0bd9f9a"
instanceType="t3.large"
ec2KeyPair="mwd-devops"
ansibleRoleVersion="releases/2.4.12"
projectVersion="releases/${version}"
appVersion="1.1.0-release"
asgServiceRoleName="AWSServiceRoleForAutoScaling_CMK1"
asgDesiredCapacity=1
asgMinCount=1
asgMaxCount=2
deploymentId=$(date | md5)
if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name site-integration-service-prod --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=environment,ParameterValue=${environment} \
    ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
    ParameterKey=kafkaStackName,ParameterValue=${kafkaStackName} \
    ParameterKey=rdsSecurityGroupId,ParameterValue=${rdsSecurityGroupId} \
    ParameterKey=enableSsh,ParameterValue=${enableSsh} \
    ParameterKey=amiId,ParameterValue=${amiId} \
    ParameterKey=instanceType,ParameterValue=${instanceType} \
    ParameterKey=instanceKeyPair,ParameterValue=${ec2KeyPair} \
    ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
    ParameterKey=asgServiceRoleName,ParameterValue=${asgServiceRoleName} \
    ParameterKey=asgDesiredCapacity,ParameterValue=${asgDesiredCapacity} \
    ParameterKey=asgMaxCount,ParameterValue=${asgMaxCount} \
    ParameterKey=asgMinCount,ParameterValue=${asgMinCount} \
    ParameterKey=projectVersion,ParameterValue=${projectVersion} \
    ParameterKey=appVersion,ParameterValue=${appVersion} \
    ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --tags \
    Key=DeployedBy,Value=mlodge-paolini \
    Key=Environment,Value=stage \
    Key=LOB,Value=mwd \
    Key=DRTier,Value=0 \
    Key=Email,Value="michael.lodge-paolini@wexinc.com" \
    Key=CreatedBy,Value=mlodge-paolini \
    Key=BillingId,Value=90530 \
    Key=Project,Value="mobile-gateway" \
    Key=Purpose,Value="gcam integration" \
    Key=CloudFormationStack,Value=site-int-service-stage \
  --output text --profile mobile-prod

else

  aws cloudformation update-stack --region us-east-1 --stack-name site-integration-service-prod  --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=environment,ParameterValue=${environment} \
    ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
    ParameterKey=kafkaStackName,ParameterValue=${kafkaStackName} \
    ParameterKey=rdsSecurityGroupId,ParameterValue=${rdsSecurityGroupId} \
    ParameterKey=enableSsh,ParameterValue=${enableSsh} \
    ParameterKey=amiId,ParameterValue=${amiId} \
    ParameterKey=instanceType,ParameterValue=${instanceType} \
    ParameterKey=instanceKeyPair,ParameterValue=${ec2KeyPair} \
    ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
    ParameterKey=asgServiceRoleName,ParameterValue=${asgServiceRoleName} \
    ParameterKey=asgDesiredCapacity,ParameterValue=${asgDesiredCapacity} \
    ParameterKey=asgMaxCount,ParameterValue=${asgMaxCount} \
    ParameterKey=asgMinCount,ParameterValue=${asgMinCount} \
    ParameterKey=projectVersion,ParameterValue=${projectVersion} \
    ParameterKey=appVersion,ParameterValue=${appVersion} \
    ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --tags \
    Key=DeployedBy,Value=mlodge-paolini \
    Key=Environment,Value=stage \
    Key=LOB,Value=mwd \
    Key=DRTier,Value=0 \
    Key=Email,Value="michael.lodge-paolini@wexinc.com" \
    Key=CreatedBy,Value=mlodge-paolini \
    Key=BillingId,Value=90530 \
    Key=Project,Value="mobile-gateway" \
    Key=Purpose,Value="gcam integration" \
    Key=CloudFormationStack,Value=site-int-service-stage \
  --output text --profile mobile-prod

fi
