#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/gasbuddy/dev/${version}/cloudformation/gasBuddy-consumer.cf.json"

if [[ "${type}" == "create" ]]; then 

  aws cloudformation create-stack --region us-east-1 --stack-name gasbuddy-consumer-stage-transys --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=stage-transys \
  ParameterKey=kinesisStackName,ParameterValue=gasbuddy-kinesis-stage-transys \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-stage-transys \
  ParameterKey=vpcStackName,ParameterValue=mobile-stage-vpc \
  ParameterKey=consumerMemory,ParameterValue=512 \
  ParameterKey=consumerTimeout,ParameterValue=300 \
  ParameterKey=artifactsBucket,ParameterValue=wex-mobile-artifacts \
  ParameterKey=consumerS3Key,ParameterValue=gasbuddy-auth-filter-1.1.0-20180627.181257-4.jar \
  ParameterKey=consumerBatchSize,ParameterValue=5 \
  --output text --profile mobile-stage

else 

  aws cloudformation update-stack --region us-east-1 --stack-name gasbuddy-consumer-stage-transys --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=stage-transys \
  ParameterKey=kinesisStackName,ParameterValue=gasbuddy-kinesis-stage-transys \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-stage-transys \
  ParameterKey=vpcStackName,ParameterValue=mobile-stage-vpc \
  ParameterKey=consumerMemory,ParameterValue=512 \
  ParameterKey=consumerTimeout,ParameterValue=300 \
  ParameterKey=artifactsBucket,ParameterValue=wex-mobile-artifacts \
  ParameterKey=consumerS3Key,ParameterValue=gasbuddy-auth-filter-1.1.0-20180627.181257-4.jar \
  ParameterKey=consumerBatchSize,ParameterValue=5 \
  --output text --profile mobile-stage

fi
