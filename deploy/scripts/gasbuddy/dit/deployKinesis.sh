#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/gasbuddy/dev/${version}/cloudformation/gasBuddy-kinesis.cf.json"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name gasbuddy-kinesis-dev --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=dev \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-dev \
  ParameterKey=kinesisShardCount,ParameterValue=10 \
  ParameterKey=kinesisRetention,ParameterValue=24 \
  ParameterKey=gasBuddyAwsAccountNumber,ParameterValue=518554605247\
  ParameterKey=devopsBucket,ParameterValue=wex-mobile-devops \
  ParameterKey=kinesisEncryptionResourceVersion,ParameterValue=0.0.1_20171216-231256 \
  --output text --profile mobile-dev

else

  aws cloudformation update-stack --region us-east-1 --stack-name gasbuddy-kinesis-dev --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=dev \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-dev \
  ParameterKey=kinesisShardCount,ParameterValue=10 \
  ParameterKey=kinesisRetention,ParameterValue=24 \
  ParameterKey=gasBuddyAwsAccountNumber,ParameterValue=518554605247\
  ParameterKey=devopsBucket,ParameterValue=wex-mobile-devops \
  ParameterKey=kinesisEncryptionResourceVersion,ParameterValue=0.0.1_20171216-231256 \
  --output text --profile mobile-dev

fi