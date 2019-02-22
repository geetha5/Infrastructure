#!/bin/bash

stack_action=$1

# Deployment Info
awsProfile="mobile-stage"
devopsS3Bucket="wex-mobile-devops"
deploymentType="releases"
deploymentVersion="latest"
deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy="${USER}"

# Parameters
envType="stage"
lineOfBusiness="mwd"
accountStackName="account-bootstrap-${envType}"
topLevelDomain="wexfleetweb.com"
platform="millennium"
vpc="vpc-27cbc45e"

# Template Info
if [[ "${deploymentVersion}" == "latest" ]]; then
coreVersion=$(aws s3 cp s3://${devopsS3Bucket}/projects/core-cf/${deploymentType}/latest.txt - | xargs)
fi

templateBaseUrl="https://${devopsS3Bucket}.s3.amazonaws.com"

coreCfPath="projects/core-cf/${deploymentType}/${coreVersion}"
policyBaseUrl="${templateBaseUrl}/${coreCfPath}/policy"
stackName="platform-bootstrap-${platform}-${envType}"
stackTemplate="${templateBaseUrl}/${coreCfPath}/Platform.template"

if [[ "${stack_action}" == "create" ]]; then
  scriptTask=create
  stackPolicy="--stack-policy-url $policyBaseUrl/prevent-all-updates.json"
else
  scriptTask=update
  stackPolicy="--stack-policy-during-update-url $policyBaseUrl/allow-all-updates.json"
fi

echo "${scriptTask} stack from: ${stackTemplate}"

aws cloudformation ${scriptTask}-stack --region us-east-1 --profile ${awsProfile} ${stackPolicy} \
    --stack-name ${stackName} --template-url ${stackTemplate} \
    --parameters \
      ParameterKey=accountStackName,ParameterValue=${accountStackName} \
      ParameterKey=platform,ParameterValue=${platform} \
      ParameterKey=envType,ParameterValue=${envType} \
      ParameterKey=vpc,ParameterValue=${vpc} \
      ParameterKey=topLevelDomain,ParameterValue=${topLevelDomain} \
      ParameterKey=deploymentId,ParameterValue=${deploymentId} \
    --tags \
      Key=DeployedBy,Value=${deployedBy} \
      Key=Environment,Value=${envType} \
      Key=LOB,Value=${lineOfBusiness} \
      Key=DRTier,Value=3 \
      Key=Email,Value="michael.lodge-paolini@wexinc.com" \
      Key=CreatedBy,Value=${deployedBy} \
      Key=BillingId,Value=90530 \
      Key=CloudFormationStack,Value=${stackName}
