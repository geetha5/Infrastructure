#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/gasbuddy/dev/${version}/cloudformation/gasBuddy-proxy.cf.json"

environment="dev"
vpcStackName="mobile-dev-vpc"
kinesisStackName="gasbuddy-kinesis-dev"
kmsStackName="gasbuddy-kms-dev"
apaAuthorizerCidr="192.168.137.200/30"
pwmAuthorizerCidr="192.168.124.0/30"
acmCertArn="arn:aws:acm:us-east-1:518554605247:certificate/babb73b6-7cd8-4ff6-8ab4-c95f238be2bc"
proxyDesiredCount=2
proxyMinCount=1
proxyMaxCount=4
enableSsh="yes"
instanceKeyPair="mwd-devops"
proxyInstanceType="t3.small"
amiId="ami-e6bd9f9c"
aesKeyParameterName="dev.auth-proxy.aesKey1"
devopsBucket="wex-mobile-devops"
ansibleVersion="dev/0.1.1_20180131-211012"
proxyVersion="1.0.0-latest"
gasBuddyProjectVersion="dev/${version}"
proxyAsgUpdateBatchSize=1
deploymentId="sjldfjoasdf9asdfou"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name gasbuddy-proxy-dev --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kinesisStackName,ParameterValue=${kinesisStackName} \
  ParameterKey=kmsStackName,ParameterValue=${kmsStackName} \
  ParameterKey=apaAuthorizerCidr,ParameterValue=${apaAuthorizerCidr} \
  ParameterKey=pwmAuthorizerCidr,ParameterValue=${pwmAuthorizerCidr} \
  ParameterKey=acmCertArn,ParameterValue=${acmCertArn} \
  ParameterKey=proxyDesiredCount,ParameterValue=${proxyDesiredCount} \
  ParameterKey=proxyMinCount,ParameterValue=${proxyMinCount} \
  ParameterKey=proxyMaxCount,ParameterValue=${proxyMaxCount} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=proxyInstanceType,ParameterValue=${proxyInstanceType} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=aesKeyParameterName,ParameterValue=${aesKeyParameterName} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=ansibleVersion,ParameterValue=${ansibleVersion} \
  ParameterKey=proxyVersion,ParameterValue=${proxyVersion} \
  ParameterKey=gasBuddyProjectVersion,ParameterValue=${gasBuddyProjectVersion} \
  ParameterKey=proxyAsgUpdateBatchSize,ParameterValue=${proxyAsgUpdateBatchSize} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-dev

else 
  aws cloudformation update-stack --region us-east-1 --stack-name gasbuddy-proxy-dev --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kinesisStackName,ParameterValue=${kinesisStackName} \
  ParameterKey=kmsStackName,ParameterValue=${kmsStackName} \
  ParameterKey=apaAuthorizerCidr,ParameterValue=${apaAuthorizerCidr} \
  ParameterKey=pwmAuthorizerCidr,ParameterValue=${pwmAuthorizerCidr} \
  ParameterKey=acmCertArn,ParameterValue=${acmCertArn} \
  ParameterKey=proxyDesiredCount,ParameterValue=${proxyDesiredCount} \
  ParameterKey=proxyMinCount,ParameterValue=${proxyMinCount} \
  ParameterKey=proxyMaxCount,ParameterValue=${proxyMaxCount} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=proxyInstanceType,ParameterValue=${proxyInstanceType} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=aesKeyParameterName,ParameterValue=${aesKeyParameterName} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=ansibleVersion,ParameterValue=${ansibleVersion} \
  ParameterKey=proxyVersion,ParameterValue=${proxyVersion} \
  ParameterKey=gasBuddyProjectVersion,ParameterValue=${gasBuddyProjectVersion} \
  ParameterKey=proxyAsgUpdateBatchSize,ParameterValue=${proxyAsgUpdateBatchSize} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  --output text --profile mobile-dev
  
fi
