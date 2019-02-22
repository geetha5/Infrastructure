#!/bin/bash

stack_action=$1
envType="dev" # ["dev", "stage", "prod"]
envInstance="sit"

# Deployment Environment Info
awsProfile="mobile-${envType}"
awsRegion="us-east-1"
devopsBucket="wex-mobile-devops"

platformName="nafleet" # usually the same as infrastructure project

# Application Artifact Info
applicationName="deuce-service"
applicationVersion="1.13.0-SNAPSHOT"

deploymentProjectName="nafleet" # e.g. salesforce, mobile-gateway, etc.
deploymentVersion="latest" #"latest"
deploymentType="dev" # "dev" or "releases"

ansibleProjectName="ansible"
ansibleVersion="2.5.4" #"latest" or specific version e.g "2.4.0"
ansibleType="releases" # "dev" or "releases"

coreProjectName="core-cf"
coreVersion="1.0.7" #"latest"
coreType="releases" # "dev" or "releases"

deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy="${USER}"

# Parameters
vpc="vpc-0b612e7adde4e6a77"
appInfrastructureStackName="${platformName}-${envInstance}-${applicationName}-base"

privateSubnets="'subnet-0d26b8dedcbd4f96f,subnet-088e67ec45537060e,subnet-0bf40463bd86f5299'"
amiId="ami-0e2ef94da725c990e"
enableSSH="yes"
ec2InstanceType="t3.medium"

asgDesiredCount=1
asgMaxCount=4
asgMinCount=1
asgUpdateBatchSize=1

if [[ "${ansibleVersion}" == "latest" ]]; then
ansibleVersion=$(aws s3 cp s3://${devopsBucket}/${ansibleProjectName}/${ansibleType}/latest.txt - | xargs)
fi

if [[ "${coreVersion}" == "latest" ]]; then
coreVersion=$(aws s3 cp s3://${devopsBucket}/projects/${coreProjectName}/${coreType}/latest.txt - | xargs)
fi

if [[ "${deploymentVersion}" == "latest" ]]; then
deploymentVersion=$(aws s3 cp s3://${devopsBucket}/projects/${deploymentProjectName}/${deploymentType}/latest.txt - | xargs)
fi


templateBaseUrl="https://$devopsBucket.s3.amazonaws.com"

coreCfPath="projects/${coreProjectName}/${coreType}/${coreVersion}"
policyBaseUrl="${templateBaseUrl}/${coreCfPath}/policy"

stackName="${platformName}-${envInstance}-${applicationName}-instance"
stackTemplate="${templateBaseUrl}/projects/${deploymentProjectName}/${deploymentType}/${deploymentVersion}/cloudformation/${applicationName}-instance.template"

if [[ "${stack_action}" == "create" ]]; then
  scriptTask=create
  stackPolicy="--stack-policy-url $policyBaseUrl/prevent-all-updates.json"
else
  scriptTask=update
  stackPolicy="--stack-policy-during-update-url $policyBaseUrl/allow-all-updates.json"
fi

echo "  STACK: ${stackTemplate}"
echo " POLICY: ${policyBaseUrl}/..."
echo "ANSIBLE: ${templateBaseUrl}/${ansibleProjectName}/${ansibleType}/${ansibleVersion}/ansible_roles.zip"

aws cloudformation ${scriptTask}-stack --region ${awsRegion} --profile ${awsProfile} ${stackPolicy} \
    --stack-name ${stackName} --template-url ${stackTemplate} \
    --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
      ParameterKey=vpc,ParameterValue=${vpc} \
      ParameterKey=appInfrastructureStackName,ParameterValue=${appInfrastructureStackName} \
      ParameterKey=envType,ParameterValue=${envType} \
      ParameterKey=envInstance,ParameterValue=${envInstance} \
      ParameterKey=privateSubnets,ParameterValue=${privateSubnets} \
      ParameterKey=deploymentId,ParameterValue=${deploymentId} \
      ParameterKey=amiId,ParameterValue=${amiId} \
      ParameterKey=enableSSH,ParameterValue=${enableSSH} \
      ParameterKey=ec2InstanceType,ParameterValue=${ec2InstanceType} \
      ParameterKey=asgDesiredCount,ParameterValue=${asgDesiredCount} \
      ParameterKey=asgMaxCount,ParameterValue=${asgMaxCount} \
      ParameterKey=asgMinCount,ParameterValue=${asgMinCount} \
      ParameterKey=asgUpdateBatchSize,ParameterValue=${asgUpdateBatchSize} \
      ParameterKey=appName,ParameterValue=${applicationName} \
      ParameterKey=appVersion,ParameterValue=${applicationVersion} \
      ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleType}/${ansibleVersion} \
      ParameterKey=infrastructureVersion,ParameterValue=${deploymentType}/${deploymentVersion} \
    --tags \
      Key=DeployedBy,Value=${deployedBy} \
      Key=Environment,Value=${envType} \
      Key=LOB,Value=mwd \
      Key=DRTier,Value=4 \
      Key=Email,Value="michael.lodge-paolini@wexinc.com" \
      Key=Principalid,Value=AIDAIC3MK46AO5I4X5M4O \
      Key=Owner,Value=${deployedBy} \
      Key=Billing,Value=90530 \
      Key=Project,Value="${deploymentProjectName}" \
      Key=Purpose,Value="${applicationName}" \
    --output text
