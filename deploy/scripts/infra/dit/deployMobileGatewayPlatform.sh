#!/bin/bash

stack_action=$1

envType="dev"
deploymentRegion="us-east-1"

platformName="core-cf"
platformType="releases" # "dev" or "releases"
platformVersion="1.0.7"

# CF Parameters
accountStackName="account-bootstrap"
platform="mobile-gateway"
topLevelDomain="wexmobileauth.com"
vpc="vpc-0b612e7adde4e6a77"

# Deployment Meta Info
lineOfBusiness="mwd"
awsProfile="mobile-${envType}"
devopsBucket="wex-mobile-devops"
deployedBy="${USER}"
deploymentDate=$(date)
deploymentId=$(date | md5)

if [[ "${platformVersion}" == "latest" ]]; then
platformVersion=$(aws s3 cp s3://${devopsBucket}/projects/${platformName}/${platformType}/latest.txt - | xargs)
fi

templateBaseUrl="https://$devopsBucket.s3.amazonaws.com"

coreCfPath="projects/${platformName}/${platformType}/${platformVersion}"
policyBaseUrl="${templateBaseUrl}/${coreCfPath}/policy"

stackName="${platform}-platform"
stackTemplate="${templateBaseUrl}/projects/${platformName}/${platformType}/${platformVersion}/Platform.template"

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
      Key=DRTier,Value=4 \
      Key=Email,Value="michael.lodge-paolini@wexinc.com" \
      Key=CreatedBy,Value=${deployedBy} \
      Key=BillingId,Value=90530 \
      Key=Project,Value="mobile-gateway" \
      Key=Purpose,Value="platform bootstrapping" \
    --output text

