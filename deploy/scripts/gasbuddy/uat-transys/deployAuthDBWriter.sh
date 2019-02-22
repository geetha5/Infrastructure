#!/bin/bash

type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/gasbuddy/dev/${version}/cloudformation/test/gasBuddy-test-auth-db-writer.cf.json"

if [[ "${type}" == "create" ]]; then 

  aws cloudformation create-stack --region us-east-1 --stack-name gasbuddy-authdbwriter-stage-transys --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=stage-transys \
  ParameterKey=kinesisStackName,ParameterValue=gasbuddy-kinesis-stage-transys \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-stage-transys \
  ParameterKey=vpcStackName,ParameterValue=mobile-stage-vpc \
  ParameterKey=memory,ParameterValue=512 \
  ParameterKey=timeout,ParameterValue=300 \
  ParameterKey=artifactsBucket,ParameterValue=wex-mobile-artifacts \
  ParameterKey=s3Key,ParameterValue=auth-db-logger-1.0.0-20180721.184411-66.jar \
  ParameterKey=batchSize,ParameterValue=50 \
  ParameterKey=rdsSecurityGroupId,ParameterValue=sg-45ef7030 \
  ParameterKey=dbHostname,ParameterValue=transys-auth-db.stage-internal.wexmobileauth.com \
  ParameterKey=dbUser,ParameterValue=stage_admin \
  ParameterKey=dbPass,ParameterValue="a1h\$3Uh843x2" \
  --output text --profile mobile-stage

else 

  aws cloudformation update-stack --region us-east-1 --stack-name gasbuddy-authdbwriter-stage-transys --template-url ${templateUrl} --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=stage-transys \
  ParameterKey=kinesisStackName,ParameterValue=gasbuddy-kinesis-stage-transys \
  ParameterKey=kmsStackName,ParameterValue=gasbuddy-kms-stage-transys \
  ParameterKey=vpcStackName,ParameterValue=mobile-stage-vpc \
  ParameterKey=memory,ParameterValue=512 \
  ParameterKey=timeout,ParameterValue=300 \
  ParameterKey=artifactsBucket,ParameterValue=wex-mobile-artifacts \
  ParameterKey=s3Key,ParameterValue=auth-db-logger-1.0.0-20180721.184411-66.jar \
  ParameterKey=batchSize,ParameterValue=50 \
  ParameterKey=rdsSecurityGroupId,ParameterValue=sg-45ef7030 \
  ParameterKey=dbHostname,ParameterValue=transys-auth-db.stage-internal.wexmobileauth.com \
  ParameterKey=dbUser,ParameterValue=stage_admin \
  ParameterKey=dbPass,ParameterValue="a1h\$3Uh843x2" \
  --output text --profile mobile-stage

fi 