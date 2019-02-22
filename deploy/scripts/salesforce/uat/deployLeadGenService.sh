#!/bin/bash

stack_action=$1
envType="stage" # ["dev", "stage", "prod"]
lineOfBusiness="mwd"

# Deployment Environment Info
awsProfile="mobile-${envType}"
awsRegion="us-east-1"
devopsBucket="wex-mobile-devops"

infrastructureProject="salesforce" # e.g. salesforce, mobile-gateway, core-cf

platformName="salesforce" # usually the same as infrastructure project
instanceName="poc" # short name for the instance of the platform this is being connected to, see PlatformInstance

# Application Artifact Info
applicationName="lead-gen-service"
applicationVersion="1.0.0"

deploymentVersion="1.0.24" #"latest"
deploymentType="releases" # "dev" or "releases"

ansibleVersion="2.4.12" #"latest" or specific version e.g "2.4.0"
ansibleType="releases" # "dev" or "releases"

coreVersion="1.0.7" #"latest"
coreType="releases" # "dev" or "releases"

deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy="${USER}"

# Parameters
vpc="vpc-27cbc45e"
accountStackName="account-bootstrap-${envType}"
platformStackName="${platformName}-platform-${envType}"
platformInstanceStackName="${platformName}-${instanceName}-${envType}"
privateSubnets="'subnet-b25f9df9,subnet-f0cdcaaa'"
publicSubnets="'subnet-c360a288,subnet-52c1c608'"
amiId="ami-e1bd9f9b"
enableSSH="yes"
instanceType="t3.large"
ec2KeyPair="mwd-devops"
desiredCapacity=2
minCount=2
maxCount=4
asgServiceRoleName="AWSServiceRoleForAutoScaling_CMK1"
asgUpdateBatchSize=1

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

stackName="${platformName}-${instanceName}-${applicationName}-${envType}"
stackTemplate="${templateBaseUrl}/projects/${infrastructureProject}/${deploymentType}/${deploymentVersion}/cloudformation/${applicationName}.template"

if [[ "${stack_action}" == "create" ]]; then
  scriptTask=create
  stackPolicy="--stack-policy-url $policyBaseUrl/prevent-all-updates.json"
else
  scriptTask=update
  stackPolicy="--stack-policy-during-update-url $policyBaseUrl/allow-all-updates.json"
fi

echo "  STACK: ${stackTemplate}"
echo " POLICY: $policyBaseUrl/prevent-all-updates.json"
echo "ANSIBLE: ${templateBaseUrl}/ansible/${ansibleType}/${ansibleVersion}/ansible_roles.zip"

aws cloudformation ${scriptTask}-stack --region ${awsRegion} --profile ${awsProfile} ${stackPolicy} \
    --stack-name ${stackName} --template-url ${stackTemplate} \
    --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
      ParameterKey=vpc,ParameterValue=${vpc} \
      ParameterKey=accountStackName,ParameterValue=${accountStackName} \
      ParameterKey=platformStackName,ParameterValue=${platformStackName} \
      ParameterKey=platformInstanceStackName,ParameterValue=${platformInstanceStackName} \
      ParameterKey=envType,ParameterValue=${envType} \
      ParameterKey=instance,ParameterValue=${instanceName} \
      ParameterKey=privateSubnets,ParameterValue=${privateSubnets} \
      ParameterKey=publicSubnets,ParameterValue=${publicSubnets} \
      ParameterKey=deploymentId,ParameterValue=${deploymentId} \
      ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
      ParameterKey=amiId,ParameterValue=${amiId} \
      ParameterKey=enableSSH,ParameterValue=${enableSSH} \
      ParameterKey=instanceType,ParameterValue=${instanceType} \
      ParameterKey=ec2KeyPair,ParameterValue=${ec2KeyPair} \
      ParameterKey=desiredCapacity,ParameterValue=${desiredCapacity} \
      ParameterKey=maxCount,ParameterValue=${maxCount} \
      ParameterKey=minCount,ParameterValue=${minCount} \
      ParameterKey=asgServiceRoleName,ParameterValue=${asgServiceRoleName} \
      ParameterKey=asgUpdateBatchSize,ParameterValue=${asgUpdateBatchSize} \
      ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleType}/${ansibleVersion} \
      ParameterKey=appVersion,ParameterValue=${applicationVersion} \
      ParameterKey=projectVersion,ParameterValue=${deploymentType}/${deploymentVersion} \
    --tags \
      Key=DeployedBy,Value=${deployedBy} \
      Key=Environment,Value=${envType} \
      Key=LOB,Value=${lineOfBusiness} \
      Key=DRTier,Value=3 \
      Key=Email,Value="michael.lodge-paolini@wexinc.com" \
      Key=CreatedBy,Value=${deployedBy} \
      Key=BillingId,Value=90530 \
      Key=Project,Value=SalesForce \
      Key=Purpose,Value="Lead Gen Service" \
    --output text
