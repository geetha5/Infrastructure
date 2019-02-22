#!/bin/bash

stack_action=$1
awsEnvironment="stage" # ["dev", "stage", "prod"]

# Deployment Environment Info
awsProfile="mobile-${awsEnvironment}"
awsRegion="us-east-1"
devopsBucket="wex-mobile-devops"

platformName="mobile-gateway" # usually the same as deploymentProjectName project
instanceName="uat" # short name for the instance of the platform this is being connected to, see PlatformInstance

# Application Artifact Info
applicationName="notification-service"
applicationVersion="1.1.3-latest"

deploymentProjectName="mobile-gateway" # e.g. salesforce, mobile-gateway, etc.
deploymentVersion="latest" #"latest"
deploymentType="dev" # "dev" or "releases"

ansibleProjectName="ansible"
ansibleVersion="2.4.11" #"latest" or specific version e.g "2.4.0"
ansibleType="releases" # "dev" or "releases"

coreProjectName="core-cf"
coreVersion="latest" #"latest"
coreType="dev" # "dev" or "releases"

deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy="${USER}"

# parameters
vpcStackName="mobile-${awsEnvironment}-vpc"
albCommonStackName="mg-alb-${awsEnvironment}"
rdsSecurityGroupId="sg-5c356c28"
enableSsh="yes"
amiId="ami-e1bd9f9b"
instanceType="t3.large"
asgServiceRoleName="AWSServiceRoleForAutoScaling_CMK1"
instanceKeyPair="mwd-devops"
desiredCapacity=2
maxCount=4
minCount=2
asgUpdateBatchSize=1
hostedZoneId="Z3FRC7D0BUOWIE"
dnsName="${applicationName}.${awsEnvironment}.wexmobileauth.com"

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

#stackName="${platformName}-${instanceName}-${applicationName}-${envType}"
stackName="${applicationName}-${awsEnvironment}"
stackTemplate="${templateBaseUrl}/projects/${deploymentProjectName}/${deploymentType}/${deploymentVersion}/cloudformation/${applicationName}.template"

if [[ "${stack_action}" == "create" ]]; then
  scriptTask=create
  stackPolicy="--stack-policy-url $policyBaseUrl/prevent-all-updates.json"
else
  scriptTask=update
  stackPolicy="--stack-policy-during-update-url $policyBaseUrl/allow-all-updates.json"
fi

echo "  STACK: ${stackTemplate}"
echo " POLICY: $policyBaseUrl/"
echo "ANSIBLE: ${templateBaseUrl}/ansible/${ansibleType}/${ansibleVersion}/ansible_roles.zip"

aws cloudformation ${scriptTask}-stack --region ${awsRegion} --profile ${awsProfile} ${stackPolicy} \
    --stack-name ${stackName} --template-url ${stackTemplate} \
    --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
      ParameterKey=environment,ParameterValue=${awsEnvironment} \
      ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
      ParameterKey=albCommonStackName,ParameterValue=${albCommonStackName} \
      ParameterKey=rdsSecurityGroupId,ParameterValue=${rdsSecurityGroupId} \
      ParameterKey=enableSsh,ParameterValue=${enableSsh} \
      ParameterKey=amiId,ParameterValue=${amiId} \
      ParameterKey=instanceType,ParameterValue=${instanceType} \
      ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
      ParameterKey=asgServiceRoleName,ParameterValue=${asgServiceRoleName} \
      ParameterKey=desiredCapacity,ParameterValue=${desiredCapacity} \
      ParameterKey=maxCount,ParameterValue=${maxCount} \
      ParameterKey=minCount,ParameterValue=${minCount} \
      ParameterKey=asgUpdateBatchSize,ParameterValue=${asgUpdateBatchSize} \
      ParameterKey=hostedZoneId,ParameterValue=${hostedZoneId} \
      ParameterKey=dnsName,ParameterValue=${dnsName} \
      ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleType}/${ansibleVersion} \
      ParameterKey=projectVersion,ParameterValue=${deploymentType}/${deploymentVersion} \
      ParameterKey=appVersion,ParameterValue=${applicationVersion} \
      ParameterKey=deploymentId,ParameterValue=${deploymentId} \
    --tags \
      Key=DeployedBy,Value=${deployedBy} \
      Key=Environment,Value=${awsEnvironment} \
      Key=LOB,Value=mwd \
      Key=DRTier,Value=3 \
      Key=Email,Value="michael.lodge-paolini@wexinc.com" \
      Key=Principalid,Value=AIDAIC3MK46AO5I4X5M4O \
      Key=Owner,Value=${deployedBy} \
      Key=Billing,Value=90530 \
      Key=Project,Value="${deploymentProjectName}" \
      Key=Purpose,Value="${applicationName}" \
    --output text
