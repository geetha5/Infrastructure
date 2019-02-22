#!/bin/bash

type=$1
version=$2


templateUrl="https://s3.amazonaws.com/wex-mobile-devops/asg-action-lambda/dev/${version}/asg-action-lambda.cf.json"

# parameters
lambdaDebug="true"
memorySize=256
timeout=300
s3CodeBucket="wex-mobile-devops"
s3CodeKey="asg-action-lambda/dev/0.0.1_20180708-232006/asg-action-lambda.jar"
s3ConfigBucket="wex-mobile-devops"
s3Configkey="config/dev/asg_action_lambda_config/config.json"
s3KmsKeyArn="none"
iamRoleAuxManagedPolicies="arn:aws:iam::518554605247:policy/instance_alarms-RW-cloudwatch,arn:aws:iam::518554605247:policy/instance-alarms-s3-RW"



if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name asg-action-lambda-dev --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=lambdaDebug,ParameterValue=${lambdaDebug} \
  ParameterKey=memorySize,ParameterValue=${memorySize} \
  ParameterKey=timeout,ParameterValue=${timeout} \
  ParameterKey=s3CodeBucket,ParameterValue=${s3CodeBucket} \
  ParameterKey=s3CodeKey,ParameterValue=${s3CodeKey} \
  ParameterKey=s3ConfigBucket,ParameterValue=${s3ConfigBucket} \
  ParameterKey=s3Configkey,ParameterValue=${s3Configkey} \
  ParameterKey=s3KmsKeyArn,ParameterValue=${s3KmsKeyArn} \
  ParameterKey=iamRoleAuxManagedPolicies,ParameterValue=${iamRoleAuxManagedPolicies} \
  --output text --profile mobile-dev


else

  aws cloudformation update-stack --region us-east-1 --stack-name asg-action-lambda-dev --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=lambdaDebug,ParameterValue=${lambdaDebug} \
  ParameterKey=memorySize,ParameterValue=${memorySize} \
  ParameterKey=timeout,ParameterValue=${timeout} \
  ParameterKey=s3CodeBucket,ParameterValue=${s3CodeBucket} \
  ParameterKey=s3CodeKey,ParameterValue=${s3CodeKey} \
  ParameterKey=s3ConfigBucket,ParameterValue=${s3ConfigBucket} \
  ParameterKey=s3Configkey,ParameterValue=${s3Configkey} \
  ParameterKey=s3KmsKeyArn,ParameterValue=${s3KmsKeyArn} \
  ParameterKey=iamRoleAuxManagedPolicies,ParameterValue=${iamRoleAuxManagedPolicies} \
  --output text --profile mobile-dev

fi
