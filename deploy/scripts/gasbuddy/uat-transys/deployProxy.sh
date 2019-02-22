#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/gasbuddy/dev/${version}/cloudformation/gasBuddy-proxy.cf.json"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name gasbuddy-proxy-stage-transys --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=stage-transys \
  ParameterKey=vpcStackName,ParameterValue=mobile-stage-vpc \
  ParameterKey=kinesisStackName,ParameterValue=gasbuddy-kinesis-stage-transys \
  ParameterKey=kafkaStackName,ParameterValue=none \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-stage-transys \
  ParameterKey=apaAuthorizerCidr,ParameterValue=192.168.137.200/30 \
  ParameterKey=pwmAuthorizerCidr,ParameterValue=192.168.124.0/30 \
  ParameterKey=acmCertArn,ParameterValue=arn:aws:acm:us-east-1:784360110492:certificate/e638692b-c763-4b28-afcd-3550296e78ae \
  ParameterKey=proxyDesiredCount,ParameterValue=4 \
  ParameterKey=proxyMinCount,ParameterValue=2 \
  ParameterKey=proxyMaxCount,ParameterValue=8 \
  ParameterKey=instanceKeyPair,ParameterValue=mwd-devops \
  ParameterKey=enableSsh,ParameterValue=yes \
  ParameterKey=proxyInstanceType,ParameterValue=t2.large \
  ParameterKey=amiId,ParameterValue=ami-6057e21a \
  ParameterKey=aesKeyParameterName,ParameterValue=stage.auth-proxy.aesKey1 \
  ParameterKey=devopsBucket,ParameterValue=wex-mobile-devops \
  ParameterKey=artifactsBucket,ParameterValue=wex-mobile-artifacts \
  ParameterKey=enableSsh,ParameterValue=yes \
  ParameterKey=ansibleVersion,ParameterValue=dev/2.2.0_20180726-173928 \
  ParameterKey=proxyVersion,ParameterValue=1.1.1-latest \
  ParameterKey=gasBuddyProjectVersion,ParameterValue="dev/${version}" \
  ParameterKey=deploymentId,ParameterValue="349sjflsjkdfkdjf" \
  ParameterKey=proxyAsgUpdateBatchSize,ParameterValue=2 \
  ParameterKey=hostedZoneId,ParameterValue=Z2SXV26ZFX8NV5 \
  ParameterKey=dnsName,ParameterValue="transys-auth-proxy.stage-internal.wexmobileauth.com" \
  --output text --profile mobile-stage

else 
  aws cloudformation update-stack --region us-east-1 --stack-name gasbuddy-proxy-stage-transys --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=stage-transys \
  ParameterKey=vpcStackName,ParameterValue=mobile-stage-vpc \
  ParameterKey=kinesisStackName,ParameterValue=gasbuddy-kinesis-stage-transys \
  ParameterKey=kafkaStackName,ParameterValue=none \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-stage-transys \
  ParameterKey=apaAuthorizerCidr,ParameterValue=192.168.137.200/30 \
  ParameterKey=pwmAuthorizerCidr,ParameterValue=192.168.124.0/30 \
  ParameterKey=acmCertArn,ParameterValue=arn:aws:acm:us-east-1:784360110492:certificate/e638692b-c763-4b28-afcd-3550296e78ae \
  ParameterKey=proxyDesiredCount,ParameterValue=4 \
  ParameterKey=proxyMinCount,ParameterValue=2 \
  ParameterKey=proxyMaxCount,ParameterValue=8 \
  ParameterKey=instanceKeyPair,ParameterValue=mwd-devops \
  ParameterKey=enableSsh,ParameterValue=yes \
  ParameterKey=proxyInstanceType,ParameterValue=t2.large \
  ParameterKey=amiId,ParameterValue=ami-6057e21a \
  ParameterKey=aesKeyParameterName,ParameterValue=stage.auth-proxy.aesKey1 \
  ParameterKey=devopsBucket,ParameterValue=wex-mobile-devops \
  ParameterKey=artifactsBucket,ParameterValue=wex-mobile-artifacts \
  ParameterKey=enableSsh,ParameterValue=yes \
  ParameterKey=ansibleVersion,ParameterValue=dev/2.2.0_20180726-173928 \
  ParameterKey=proxyVersion,ParameterValue=1.1.1-latest \
  ParameterKey=gasBuddyProjectVersion,ParameterValue="dev/${version}" \
  ParameterKey=deploymentId,ParameterValue="3492dfksjlfkjdjf" \
  ParameterKey=proxyAsgUpdateBatchSize,ParameterValue=2 \
  ParameterKey=hostedZoneId,ParameterValue=Z2SXV26ZFX8NV5 \
  ParameterKey=dnsName,ParameterValue="transys-auth-proxy.stage-internal.wexmobileauth.com" \
  --output text --profile mobile-stage
  
fi
