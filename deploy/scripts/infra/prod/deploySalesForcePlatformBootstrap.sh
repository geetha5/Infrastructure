#!/bin/bash

stack_action=$1

envType="prod"

# Deployment Info
devopsBucket="wex-mobile-devops"
deploymentRegion="us-east-1"
deploymentProject="core-cf"
deploymentType="releases"
deploymentVersion="1.0.5"
deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy="${USER}"

# Parameters
awsProfile="mobile-${envType}"
lineOfBusiness="mwd"
accountStackName="account-bootstrap-${envType}"
topLevelDomain="fleetcardappservices.com"
platform="salesforce"
vpc="vpc-9a6b82e2"

coreVersion="1.0.5"
coreType="releases" # "dev" or "releases"

if [[ "${coreVersion}" == "latest" ]]; then
coreVersion=$(aws s3 cp s3://${devopsBucket}/projects/core-cf/${coreType}/latest.txt - | xargs)
fi

if [[ "${deploymentVersion}" == "latest" ]]; then
deploymentVersion=$(aws s3 cp s3://${devopsBucket}/projects/${deploymentProject}/${deploymentType}/latest.txt - | xargs)
fi


templateBaseUrl="https://$devopsBucket.s3.amazonaws.com"

coreCfPath="projects/core-cf/${deploymentType}/${coreVersion}"
policyBaseUrl="${templateBaseUrl}/${coreCfPath}/policy"

stackName="${platform}-platform-${envType}"
stackTemplate="${templateBaseUrl}/projects/${deploymentProject}/${deploymentType}/${deploymentVersion}/Platform.template"

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
      Key=DRTier,Value=0 \
      Key=Email,Value="michael.lodge-paolini@wexinc.com" \
      Key=CreatedBy,Value=${deployedBy} \
      Key=BillingId,Value=90530 \
      Key=CloudFormationStack,Value=${stackName}
