#!/bin/bash

stack_action=$1

envType="dev"

# Deployment Info
awsProfile="mobile-${envType}"
devopsBucket="wex-mobile-devops"
deploymentRegion="us-east-1"
deploymentProject="card-benefits"
deploymentType="dev" # "dev" or "releases"
deploymentVersion="latest"
deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy="${USER}"

# Parameters
lineOfBusiness="mwd"
platform="card-benefits"
instance="dit"
accountStackName="account-bootstrap"
platformStackName="${platform}-platform"
vpc="vpc-0b612e7adde4e6a77"
publicSubnets="'subnet-00f8ab8688b6397f9,subnet-034fa75477a0990ca,subnet-06047f831d9a40b2e'"
privateSubnets="'subnet-088e67ec45537060e,subnet-0bf40463bd86f5299,subnet-0d26b8dedcbd4f96f'"

coreVersion="latest"
coreType="dev" # "dev" or "releases"

if [[ "${coreVersion}" == "latest" ]]; then
coreVersion=$(aws s3 cp s3://${devopsBucket}/projects/core-cf/${coreType}/latest.txt - | xargs)
fi

if [[ "${deploymentVersion}" == "latest" ]]; then
deploymentVersion=$(aws s3 cp s3://${devopsBucket}/projects/${deploymentProject}/${deploymentType}/latest.txt - | xargs)
fi

templateBaseUrl="https://$devopsBucket.s3.amazonaws.com"

coreCfPath="projects/core-cf/${coreType}/${coreVersion}"
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
    --stack-name ${stackName} --template-url ${stackTemplate} --output text \
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
      Key=DRTier,Value=4 \
      Key=Email,Value="michael.lodge-paolini@wexinc.com" \
      Key=CreatedBy,Value=${deployedBy} \
      Key=BillingId,Value=90530 \
      Key=CloudFormationStack,Value=${stackName}
