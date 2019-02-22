#!/bin/bash

stack_action=$1
envType="dev" # ["dev", "stage", "prod"]
lineOfBusiness="mwd"

# Deployment Environment Info
awsProfile="mobile-${envType}"
awsRegion="us-east-1"
devopsBucket="wex-mobile-devops"

infrastructureProject="card-benefits" # e.g. salesforce, mobile-gateway, core-cf

platformName="card-benefits" # usually the same as infrastructure project
instanceName="dit" # short name for the instance of the platform this is being connected to, see PlatformInstance

# Application Artifact Info
applicationName="card-benefits-ui"
applicationVersion="1.0.0-rc.2"  #deployed artifact (nexus/artifactory/etc.)

deploymentVersion="latest" #"latest"
deploymentType="dev" # "dev" or "releases"

ansibleVersion="latest" #"latest" or specific version e.g "2.4.0"
ansibleType="dev" # "dev" or "releases"

coreVersion="latest" #"latest"
coreType="dev" # "dev" or "releases"

deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy="${USER}"

# parameters
vpc="vpc-0b612e7adde4e6a77"
accountStackName="account-bootstrap"
platformInstanceStackName="${platformName}-${instanceName}-${envType}"
platformStackName="${platformName}-platform"

if [[ "${ansibleVersion}" == "latest" ]]; then
ansibleVersion=$(aws s3 cp s3://${devopsBucket}/ansible/${ansibleType}/latest.txt - | xargs)
fi

if [[ "${coreVersion}" == "latest" ]]; then
coreVersion=$(aws s3 cp s3://${devopsBucket}/projects/core-cf/${coreType}/latest.txt - | xargs)
fi

if [[ "${deploymentVersion}" == "latest" ]]; then
deploymentVersion=$(aws s3 cp s3://${devopsBucket}/projects/${infrastructureProject}/${deploymentType}/latest.txt - | xargs)
fi


templateBaseUrl="https://$devopsBucket.s3.amazonaws.com"

coreCfPath="projects/core-cf/${coreType}/${coreVersion}"
policyBaseUrl="${templateBaseUrl}/${coreCfPath}/policy"

stackName="${platformName}-${instanceName}-${applicationName}"
stackTemplate="${templateBaseUrl}/projects/${infrastructureProject}/${deploymentType}/${deploymentVersion}/cloudformation/${applicationName}.template"

if [[ "${stack_action}" == "create" ]]; then
  scriptTask=create
  stackPolicy="--stack-policy-url $policyBaseUrl/prevent-all-updates.json"
else
  scriptTask=update
  stackPolicy="--stack-policy-during-update-url $policyBaseUrl/allow-all-updates.json"
fi

echo "  STACK: ${stackTemplate}"
echo " POLICY: ${policyBaseUrl}/..."
echo "ANSIBLE: ${templateBaseUrl}/ansible/${ansibleType}/${ansibleVersion}/ansible_roles.zip"

aws cloudformation ${scriptTask}-stack --region ${awsRegion} --profile ${awsProfile} ${stackPolicy} \
    --stack-name ${stackName} --template-url ${stackTemplate} \
    --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
      ParameterKey=envType,ParameterValue=${envType} \
      ParameterKey=accountStackName,ParameterValue=${accountStackName} \
      ParameterKey=platformStackName,ParameterValue=${platformStackName} \
      ParameterKey=platformInstanceStackName,ParameterValue=${platformInstanceStackName} \
      ParameterKey=instance,ParameterValue=${instanceName} \
      ParameterKey=applicationName,ParameterValue=${applicationName} \
      ParameterKey=applicationBuildId,ParameterValue=${applicationName}-${applicationVersion} \
    --tags \
      Key=DeployedBy,Value=${deployedBy} \
      Key=Environment,Value=${envType} \
      Key=LOB,Value=${lineOfBusiness} \
      Key=DRTier,Value=4 \
      Key=Email,Value="michael.lodge-paolini@wexinc.com" \
      Key=CreatedBy,Value=${deployedBy} \
      Key=BillingId,Value=90530 \
      Key=Project,Value="${infrastructureProject}" \
      Key=Purpose,Value="${applicationName}" \
    --output text
