#!/bin/bash

stack_action=$1

deploymentType="dev" # "dev" or "releases"
deploymentVersion="latest"

coreType="dev" # "dev" or "releases"
coreVersion="latest"

# Parameters
envType="dev"
lineOfBusiness="mwd"
snsDevOpsEmail="michael.lodge-paolini@wexinc.com"
deployedBy="${USER}"
vpc="vpc-0b612e7adde4e6a77"

# Deployment Info
awsProfile="mobile-${envType}"
devopsBucket="wex-mobile-devops"
deploymentProject="core-cf"
deploymentRegion="us-east-1"

deploymentDate=$(date)
deploymentId=$(date | md5)

if [[ "${coreVersion}" == "latest" ]]; then
coreVersion=$(aws s3 cp s3://${devopsBucket}/projects/core-cf/${coreType}/latest.txt - | xargs)
fi

if [[ "${deploymentVersion}" == "latest" ]]; then
deploymentVersion=$(aws s3 cp s3://${devopsBucket}/projects/${deploymentProject}/${deploymentType}/latest.txt - | xargs)
fi

templateBaseUrl="https://$devopsBucket.s3.amazonaws.com"

coreCfPath="projects/core-cf/${coreType}/${coreVersion}"
policyBaseUrl="${templateBaseUrl}/${coreCfPath}/policy"

stackName="account-bootstrap"
stackTemplate="${templateBaseUrl}/projects/${deploymentProject}/${deploymentType}/${deploymentVersion}/Account.template"

if [[ "${stack_action}" == "create" ]]; then
  scriptTask=create
  stackPolicy="--stack-policy-url $policyBaseUrl/prevent-all-updates.json"
else
  scriptTask=update
  stackPolicy="--stack-policy-during-update-url $policyBaseUrl/allow-all-updates.json"
fi

echo "${scriptTask} stack from: ${stackTemplate}"

aws cloudformation ${scriptTask}-stack --stack-name ${stackName} --template-url ${stackTemplate} \
    --region ${deploymentRegion} --profile ${awsProfile} ${stackPolicy} \
    --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
      ParameterKey=s3Url,ParameterValue=${templateBaseUrl} \
      ParameterKey=s3Bucket,ParameterValue=${devopsBucket} \
      ParameterKey=coreCfPath,ParameterValue=${coreCfPath} \
      ParameterKey=vpc,ParameterValue=${vpc} \
      ParameterKey=envType,ParameterValue=${envType} \
      ParameterKey=lineOfBusiness,ParameterValue=${lineOfBusiness} \
      ParameterKey=snsDevOpsEmail,ParameterValue=${snsDevOpsEmail} \
    --tags \
      Key=DeployedBy,Value=${deployedBy} \
      Key=Environment,Value=${envType} \
      Key=LOB,Value=${lineOfBusiness} \
      Key=DRTier,Value=4 \
      Key=Email,Value=${snsDevOpsEmail} \
      Key=CreatedBy,Value=${deployedBy} \
      Key=BillingId,Value=90530 \
      Key=Project,Value="Account Infrastructure" \
      Key=Purpose,Value="Account Bootstrapping" \
    --output text
