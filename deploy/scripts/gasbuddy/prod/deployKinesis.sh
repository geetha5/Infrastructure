#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/gasbuddy/releases/${version}/cloudformation/gasBuddy-kinesis.cf.json"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name gasbuddy-kinesis-prod --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=prod \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-prod \
  ParameterKey=kinesisShardCount,ParameterValue=20 \
  ParameterKey=kinesisRetention,ParameterValue=168 \
  ParameterKey=gasBuddyAwsAccountNumber,ParameterValue=896521799855\
  ParameterKey=devopsBucket,ParameterValue=wex-mobile-devops \
  ParameterKey=kinesisEncryptionResourceReleaseType,ParameterValue=releases \
  ParameterKey=kinesisEncryptionResourceVersion,ParameterValue=0.0.1 \
  --output text --profile mobile-prod

else

  aws cloudformation update-stack --region us-east-1 --stack-name gasbuddy-kinesis-prod --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=prod \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-prod \
  ParameterKey=kinesisShardCount,ParameterValue=20 \
  ParameterKey=kinesisRetention,ParameterValue=168 \
  ParameterKey=gasBuddyAwsAccountNumber,ParameterValue=896521799855\
  ParameterKey=devopsBucket,ParameterValue=wex-mobile-devops \
  ParameterKey=kinesisEncryptionResourceReleaseType,ParameterValue=releases \
  ParameterKey=kinesisEncryptionResourceVersion,ParameterValue=0.0.1 \
  --output text --profile mobile-prod 

fi