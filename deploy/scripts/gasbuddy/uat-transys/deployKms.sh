#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/gasbuddy/dev/${version}/cloudformation/gasBuddy-kms.cf.json"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name gasbuddy-kms-stage-transys --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=stage-transys \
  ParameterKey=enableGasbuddy,ParameterValue=yes \
  --output text --profile mobile-stage

else

  aws cloudformation update-stack --region us-east-1 --stack-name gasbuddy-kms-stage-transys --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=stage-transys \
  ParameterKey=enableGasbuddy,ParameterValue=yes \
  --output text --profile mobile-stage

fi