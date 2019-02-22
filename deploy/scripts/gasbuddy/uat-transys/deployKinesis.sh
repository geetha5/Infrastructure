#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/gasbuddy/dev/${version}/cloudformation/gasBuddy-kinesis.cf.json"

if [[ "${type}" == "create" ]]; then

aws cloudformation create-stack --region us-east-1 --stack-name gasbuddy-kinesis-stage-transys --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
ParameterKey=environment,ParameterValue=stage-transys \
ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-stage-transys \
ParameterKey=kinesisShardCount,ParameterValue=20 \
ParameterKey=kinesisRetention,ParameterValue=24 \
ParameterKey=gasBuddyAwsAccountNumber,ParameterValue=stream-only \
ParameterKey=devopsBucket,ParameterValue=wex-mobile-devops \
ParameterKey=kinesisEncryptionResourceReleaseType,ParameterValue=releases \
ParameterKey=kinesisEncryptionResourceVersion,ParameterValue=0.0.1 \
--output text --profile mobile-stage

else 

aws cloudformation update-stack --region us-east-1 --stack-name gasbuddy-kinesis-stage-transys --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
ParameterKey=environment,ParameterValue=stage-transys \
ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-stage-transys \
ParameterKey=kinesisShardCount,ParameterValue=20 \
ParameterKey=kinesisRetention,ParameterValue=24 \
ParameterKey=gasBuddyAwsAccountNumber,ParameterValue=stream-only \
ParameterKey=devopsBucket,ParameterValue=wex-mobile-devops \
ParameterKey=kinesisEncryptionResourceReleaseType,ParameterValue=releases \
  ParameterKey=kinesisEncryptionResourceVersion,ParameterValue=0.0.1 \
--output text --profile mobile-stage

fi 