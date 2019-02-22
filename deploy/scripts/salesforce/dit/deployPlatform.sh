#!/bin/bash

type=$1

devopsS3Bucket=wex-mobile-devops
awsProfile=mobile-dev

# parameters
lineOfBusiness=mwd
envType=dev
envShortName=poc
accountStackName=${lineOfBusiness}-${envType}-account-resources
vpc=vpc-41c2cd38
publicSubnets="'subnet-7eea2835,subnet-7656512c'"
privateSubnets="'subnet-95df1dde,subnet-c656519c'"

deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy=${USER}

projectVersion=$(aws s3 cp s3://${devopsS3Bucket}/projects/wol/dev/latest.txt - | xargs)
coreVersion=$(aws s3 cp s3://${devopsS3Bucket}/projects/core-cf/dev/latest.txt - | xargs)
templateBaseUrl="https://$devopsS3Bucket.s3.amazonaws.com"

stackName=${lineOfBusiness}-${envType}-salesforce-${envShortName}
stackTemplate="$templateBaseUrl/projects/core-cf/dev/$coreVersion/Platform.template"
policyBaseUrl="$templateBaseUrl/projects/core-cf/dev/$coreVersion/policy"

if [[ "${type}" == "create" ]]; then
  scriptTask=create-stack
  stackPolicy="--stack-policy-url $policyBaseUrl/prevent-all-updates.json"
else
  scriptTask=update-stack
  stackPolicy="--stack-policy-during-update-url $policyBaseUrl/allow-all-updates.json"
fi

#create-change-set

aws cloudformation ${scriptTask} --region us-east-1 \
    --stack-name ${stackName} \
    --template-url ${stackTemplate} \
    ${stackPolicy} \
    --profile ${awsProfile} \
    --parameters \
  ParameterKey=envType,ParameterValue=${envType} \
  ParameterKey=vpc,ParameterValue=${vpc} \
  ParameterKey=accountStackName,ParameterValue=${accountStackName} \
  ParameterKey=envShortName,ParameterValue=${envShortName} \
  ParameterKey=publicSubnets,ParameterValue=${publicSubnets} \
  ParameterKey=privateSubnets,ParameterValue=${privateSubnets} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
    --tags \
      Key=DeployedBy,Value=${deployedBy} \
      Key=Environment,Value=${envType} \
      Key=LOB,Value=${lineOfBusiness} \
      Key=DRTier,Value=4 \
      Key=Email,Value="michael.lodge-paolini@wexinc.com" \
      Key=CreatedBy,Value=${deployedBy} \
      Key=BillingId,Value=90530 \
      Key=CloudFormationStack,Value=${stackName}
