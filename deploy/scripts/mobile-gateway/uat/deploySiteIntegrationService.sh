#!/bin/bash

stack_action=$1
envType="stage" # ["dev", "stage", "prod"]
lineOfBusiness="mwd"

# Deployment Environment Info
awsProfile="mobile-${envType}"
awsRegion="us-east-1"
devopsBucket="wex-mobile-devops"

infrastructureProject="mobile-gateway" # e.g. salesforce, mobile-gateway, core-cf

platformName="mg" # usually the same as infrastructure project
instanceName="uat" # short name for the instance of the platform this is being connected to, see PlatformInstance

# Application Artifact Info
applicationName="site-integration-service"
applicationVersion="1.1.0-release"  #deployed artifact (nexus/artifactory/etc.)

deploymentVersion="2.2.7" #"latest"
deploymentType="releases" # "dev" or "releases"

ansibleVersion="2.4.13_20190118-184325" #"latest" or specific version e.g "2.4.0"
ansibleType="dev" # "dev" or "releases"

coreVersion="1.0.7" #"latest"
coreType="releases" # "dev" or "releases"

deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy="${USER}"

# parameters
vpcStackName="mobile-stage-vpc"
kafkaStackName="mg-kafka-stage"
rdsSecurityGroupId="sg-5c356c28"
enableSsh="yes"
amiId="ami-e1bd9f9b"
instanceType="t3.large"
ec2KeyPair="mwd-devops"
asgServiceRoleName="AWSServiceRoleForAutoScaling_CMK1"
asgDesiredCapacity=1
asgMinCount=1
asgMaxCount=2

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

#stackName="${platformName}-${instanceName}-${applicationName}-${envType}"
stackName="${applicationName}-${envType}"
stackTemplate="${templateBaseUrl}/projects/${infrastructureProject}/${deploymentType}/${deploymentVersion}/cloudformation/${applicationName}.template"

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
    ParameterKey=environment,ParameterValue=${envType} \
    ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
    ParameterKey=kafkaStackName,ParameterValue=${kafkaStackName} \
    ParameterKey=rdsSecurityGroupId,ParameterValue=${rdsSecurityGroupId} \
    ParameterKey=enableSsh,ParameterValue=${enableSsh} \
    ParameterKey=amiId,ParameterValue=${amiId} \
    ParameterKey=instanceType,ParameterValue=${instanceType} \
    ParameterKey=instanceKeyPair,ParameterValue=${ec2KeyPair} \
    ParameterKey=asgServiceRoleName,ParameterValue=${asgServiceRoleName} \
    ParameterKey=asgDesiredCapacity,ParameterValue=${asgDesiredCapacity} \
    ParameterKey=asgMaxCount,ParameterValue=${asgMaxCount} \
    ParameterKey=asgMinCount,ParameterValue=${asgMinCount} \
    ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleType}/${ansibleVersion} \
    ParameterKey=projectVersion,ParameterValue=${deploymentType}/${deploymentVersion} \
    ParameterKey=appVersion,ParameterValue=${applicationVersion} \
    ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --tags \
    Key=DeployedBy,Value=${deployedBy} \
    Key=Environment,Value=${envType} \
    Key=LOB,Value=mwd \
    Key=DRTier,Value=3 \
    Key=Email,Value="michael.lodge-paolini@wexinc.com" \
    Key=Principalid,Value=AIDAIC3MK46AO5I4X5M4O \
    Key=Owner,Value=${deployedBy} \
    Key=Billing,Value=90530 \
    Key=Project,Value="${infrastructureProject}" \
    Key=Purpose,Value="${applicationName}" \
  --output text
