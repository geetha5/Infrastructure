#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/gasbuddy/releases/${version}/cloudformation/gasBuddy-consumer.cf.json"

if [[ "${type}" == "create" ]]; then 

  aws cloudformation create-stack --region us-east-1 --stack-name gasbuddy-consumer-prod --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=prod \
  ParameterKey=kinesisStackName,ParameterValue=gasbuddy-kinesis-prod \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-prod \
  ParameterKey=vpcStackName,ParameterValue=mobile-prod-vpc \
  ParameterKey=consumerMemory,ParameterValue=512 \
  ParameterKey=consumerTimeout,ParameterValue=300 \
  ParameterKey=artifactsBucket,ParameterValue=wex-mobile-artifacts \
  ParameterKey=consumerS3Key,ParameterValue=gasbuddy-auth-filter-1.1.0.jar \
  ParameterKey=consumerBatchSize,ParameterValue=5 \
  --output text --profile mobile-prod

else 

  aws cloudformation update-stack --region us-east-1 --stack-name gasbuddy-consumer-prod --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=prod \
  ParameterKey=kinesisStackName,ParameterValue=gasbuddy-kinesis-prod \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-prod \
  ParameterKey=vpcStackName,ParameterValue=mobile-prod-vpc \
  ParameterKey=consumerMemory,ParameterValue=512 \
  ParameterKey=consumerTimeout,ParameterValue=300 \
  ParameterKey=artifactsBucket,ParameterValue=wex-mobile-artifacts \
  ParameterKey=consumerS3Key,ParameterValue=gasbuddy-auth-filter-1.1.0.jar \
  ParameterKey=consumerBatchSize,ParameterValue=5 \
  --output text --profile mobile-prod

fi