#!/bin/bash

stack_action=$1

envType="prod"

# Deployment Info
awsProfile="mobile-${envType}"
devopsBucket="wex-mobile-devops"
deploymentRegion="us-east-1"
deploymentProject="salesforce"
deploymentType="releases" # "dev" or "releases"
deploymentVersion="1.0.19"
deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy="${USER}"

# Parameters
lineOfBusiness="mwd"
platform="salesforce"
instance="blue"
accountStackName="account-bootstrap-${envType}"
platformStackName="${platform}-platform-${envType}"
vpc="vpc-9a6b82e2"
privateSubnets="'subnet-72cacd28,subnet-07219463'"
publicSubnets="'subnet-a8cccbf2,subnet-75219411'"

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

stackName="${platform}-${instance}-${envType}"
stackTemplate="${templateBaseUrl}/projects/${deploymentProject}/${deploymentType}/${deploymentVersion}/cloudformation/PlatformInstance.template"

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
      ParameterKey=vpc,ParameterValue=${vpc} \
      ParameterKey=accountStackName,ParameterValue=${accountStackName} \
      ParameterKey=platformStackName,ParameterValue=${platformStackName} \
      ParameterKey=envType,ParameterValue=${envType} \
      ParameterKey=instance,ParameterValue=${instance} \
      ParameterKey=publicSubnets,ParameterValue=${publicSubnets} \
      ParameterKey=privateSubnets,ParameterValue=${privateSubnets} \
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
