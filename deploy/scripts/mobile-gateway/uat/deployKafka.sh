#!/bin/bash

stack_action=$1

# Deployment Info
awsProfile="mobile-stage"
devopsS3Bucket="wex-mobile-devops"
deploymentRegion="us-east-1"
deploymentType="dev"
deploymentVersion="latest"
deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy="${USER}"

# Parameters
environment="stage"
clusterPurpose="mg"
vpcStackName="mobile-stage-vpc"
enableSsh="yes"
amiId="ami-e1bd9f9b"
instanceType="m4.large"
diskSize="300"
instanceKeyPair="mwd-devops"
hostedZoneId="ZFJP39NGUEQPR"

ansibleRoleVersion="releases/2.4.2"
coreVersion="releases/1.0.2"
#coreVersion=$(aws s3 cp s3://${devopsS3Bucket}/projects/core-cf/${deploymentType}/latest.txt - | xargs)

if [[ "${deploymentVersion}" == "latest" ]]; then
deploymentVersion=$(aws s3 cp s3://${devopsS3Bucket}/projects/kafka/${deploymentType}/latest.txt - | xargs)
fi

templateBaseUrl="https://$devopsS3Bucket.s3.amazonaws.com"

coreCfPath="projects/core-cf/${deploymentType}/${coreVersion}"
policyBaseUrl="${templateBaseUrl}/${coreCfPath}/policy"

stackName="mg-kafka-${environment}"
stackTemplate="${templateBaseUrl}/projects/kafka/${deploymentType}/${deploymentVersion}/cloudformation/selfcontained.cf.json"

if [[ "${stack_action}" == "create" ]]; then
  scriptTask=create
  stackPolicy="--stack-policy-url $policyBaseUrl/prevent-all-updates.json"
else
  scriptTask=update
  stackPolicy="--stack-policy-during-update-url $policyBaseUrl/allow-all-updates.json"
fi

echo "${scriptTask} stack from: ${stackTemplate}"

aws cloudformation ${scriptTask}-stack --region ${deploymentRegion} --profile ${awsProfile} ${stackPolicy} \
    --stack-name ${stackName} --template-url ${stackTemplate} \
    --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
      ParameterKey=environment,ParameterValue=${environment} \
      ParameterKey=clusterPurpose,ParameterValue=${clusterPurpose} \
      ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
      ParameterKey=enableSsh,ParameterValue=${enableSsh} \
      ParameterKey=amiId,ParameterValue=${amiId} \
      ParameterKey=instanceType,ParameterValue=${instanceType} \
      ParameterKey=diskSize,ParameterValue=${diskSize} \
      ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
      ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
      ParameterKey=kafkaInfrastructureVersion,ParameterValue=${deploymentType}/${deploymentVersion} \
      ParameterKey=hostedZoneId,ParameterValue=${hostedZoneId} \
      ParameterKey=deploymentId,ParameterValue=${deploymentId} \
    --output text
