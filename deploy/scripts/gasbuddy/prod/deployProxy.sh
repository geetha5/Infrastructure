#!/bin/bash

stack_action=$1
envType="prod" # ["dev", "stage", "prod"]
lineOfBusiness="mwd"

awsProfile="mobile-${envType}"
awsRegion="us-east-1"
devopsBucket="wex-mobile-devops"

infrastructureProject="gasbuddy" # e.g. salesforce, mobile-gateway, core-cf

deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy="${USER}"

deploymentVersion="2.0.1" #"latest"
deploymentType="releases" # "dev" or "releases"

coreVersion="1.0.5" #"latest"
coreType="releases" # "dev" or "releases"

ansibleVersion="2.4.9" #"latest" or specific version e.g "2.4.0"
ansibleType="releases" # "dev" or "releases"

if [[ "${coreVersion}" == "latest" ]]; then
coreVersion=$(aws s3 cp s3://${devopsBucket}/projects/core-cf/${coreType}/latest.txt - | xargs)
fi

if [[ "${ansibleVersion}" == "latest" ]]; then
ansibleVersion=$(aws s3 cp s3://${devopsBucket}/ansible/${ansibleType}/latest.txt - | xargs)
fi

if [[ "${deploymentVersion}" == "latest" ]]; then
deploymentVersion=$(aws s3 cp s3://${devopsBucket}/projects/${infrastructureProject}/${deploymentType}/latest.txt - | xargs)
fi

# Parameters
vpcStackName="mobile-${envType}-vpc"
kinesisStackName="gasbuddy-kinesis-${envType}"
kafkaStackName="kafka-common-${envType}"
kmsStackName="gasbuddy-kms-${envType}"
apaAuthorizerCidr="192.168.224.0/29"
pwmAuthorizerCidr="192.168.237.0/28"
acmCertArn="arn:aws:acm:us-east-1:032744083734:certificate/762765ce-3ae4-417c-b48d-d4d75e346bfd"
asgServiceRoleName="AWSServiceRoleForAutoScaling_CMK1"
proxyDesiredCount=4
proxyMinCount=2
proxyMaxCount=8
instanceKeyPair="mwd-devops"
enableSsh="no"
proxyInstanceType="t3.large"
amiId="ami-e0bd9f9a"
aesKeyParameterName="${envType}.auth-proxy.aesKey1"
artifactsBucket="wex-mobile-artifacts"
proxyVersion="1.1.0-release"
gasBuddyProjectVersion="releases/${deploymentVersion}"
proxyAsgUpdateBatchSize=2
hostedZoneId="ZEYHXRD2ZFE72"
dnsName="prod-auth-proxy.internal.wexmobileauth.com"

templateBaseUrl="https://$devopsBucket.s3.amazonaws.com"
policyBaseUrl="${templateBaseUrl}/projects/core-cf/${coreType}/${coreVersion}/policy"

if [[ "${stack_action}" == "create" ]]; then
  scriptTask=create
  stackPolicy="--stack-policy-url $policyBaseUrl/prevent-all-updates.json"
else
  scriptTask=update
  stackPolicy="--stack-policy-during-update-url $policyBaseUrl/allow-all-updates.json"
fi

stackName="gasbuddy-proxy-${envType}"
stackTemplate="https://s3.amazonaws.com/${devopsBucket}/projects/${infrastructureProject}/${deploymentType}/${deploymentVersion}/cloudformation/gasBuddy-proxy.cf.json"

echo "INFO: ${scriptTask} stack from: ${stackTemplate}"
echo ""

aws cloudformation ${scriptTask}-stack --region ${awsRegion} --profile ${awsProfile} ${stackPolicy} \
  --stack-name ${stackName} \
  --template-url ${stackTemplate} \
  --capabilities CAPABILITY_IAM \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=environment,ParameterValue=${envType} \
    ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
    ParameterKey=kinesisStackName,ParameterValue=${kinesisStackName} \
    ParameterKey=kafkaStackName,ParameterValue=${kafkaStackName} \
    ParameterKey=kmsStackName,ParameterValue=${kmsStackName} \
    ParameterKey=apaAuthorizerCidr,ParameterValue=${apaAuthorizerCidr} \
    ParameterKey=pwmAuthorizerCidr,ParameterValue=${pwmAuthorizerCidr} \
    ParameterKey=acmCertArn,ParameterValue=${acmCertArn} \
    ParameterKey=asgServiceRoleName,ParameterValue=${asgServiceRoleName} \
    ParameterKey=proxyDesiredCount,ParameterValue=${proxyDesiredCount} \
    ParameterKey=proxyMinCount,ParameterValue=${proxyMinCount} \
    ParameterKey=proxyMaxCount,ParameterValue=${proxyMaxCount} \
    ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
    ParameterKey=enableSsh,ParameterValue=${enableSsh} \
    ParameterKey=proxyInstanceType,ParameterValue=${proxyInstanceType} \
    ParameterKey=amiId,ParameterValue=${amiId} \
    ParameterKey=aesKeyParameterName,ParameterValue=${aesKeyParameterName} \
    ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
    ParameterKey=artifactsBucket,ParameterValue=${artifactsBucket} \
    ParameterKey=ansibleVersion,ParameterValue=${ansibleType}/${ansibleVersion} \
    ParameterKey=proxyVersion,ParameterValue=${proxyVersion} \
    ParameterKey=gasBuddyProjectVersion,ParameterValue="${deploymentType}/${deploymentVersion}" \
    ParameterKey=deploymentId,ParameterValue=${deploymentId} \
    ParameterKey=proxyAsgUpdateBatchSize,ParameterValue=${proxyAsgUpdateBatchSize} \
    ParameterKey=hostedZoneId,ParameterValue=${hostedZoneId} \
    ParameterKey=dnsName,ParameterValue=${dnsName} \
  --tags \
    Key=DeployedBy,Value=${deployedBy} \
    Key=Environment,Value=${envType} \
    Key=LOB,Value=${lineOfBusiness} \
    Key=DRTier,Value=0 \
    Key=Email,Value="michael.lodge-paolini@wexinc.com" \
    Key=CreatedBy,Value=${deployedBy} \
    Key=BillingId,Value=90530 \
    Key=Project,Value=GasBuddy \
    Key=CloudFormationStack,Value=${stackName} \
  --output text

echo ""
