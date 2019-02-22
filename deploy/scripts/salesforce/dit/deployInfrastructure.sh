#!/bin/bash

type=$1

devopsS3Bucket=wex-mobile-devops
awsProfile=mobile-dev

# parameters
lineOfBusiness=mwd
envType=dev
envShortName=poc
vpc=vpc-41c2cd38

accountStackName=${lineOfBusiness}-${envType}-account-resources
envStackName=${lineOfBusiness}-${envType}-mp-${envShortName}

deploymentDate=$(date)
deploymentId=$(date | md5)
deployedBy=${USER}

dbUsername=LeadGenAdmin
dbPassword="Vl6xv1kPrsUAE2QozyX8ngmatUUF5CwG"
#dbPassword="'$(aws secretsmanager get-random-password --exclude-punctuation --output=text)'"
#echo "DB Password: ${dbPassword}"

projectVersion=$(aws s3 cp s3://${devopsS3Bucket}/projects/salesforce/dev/latest.txt - | xargs)
coreVersion=$(aws s3 cp s3://${devopsS3Bucket}/projects/core-cf/dev/latest.txt - | xargs)
templateBaseUrl="https://$devopsS3Bucket.s3.amazonaws.com"

stackName=${lineOfBusiness}-${envType}-mp-${envShortName}-salesforce-infrastructure
stackTemplate=${templateBaseUrl}/projects/salesforce/dev/${projectVersion}/cloudformation/sf-infrastructure.template
policyBaseUrl=${templateBaseUrl}/projects/core-cf/dev/${coreVersion}/policy

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
  ParameterKey=accountStackName,ParameterValue=${accountStackName} \
  ParameterKey=envStackName,ParameterValue=${envStackName} \
  ParameterKey=lineOfBusiness,ParameterValue=${lineOfBusiness} \
  ParameterKey=envType,ParameterValue=${envType} \
  ParameterKey=vpc,ParameterValue=${vpc} \
  ParameterKey=dbUsername,ParameterValue=${dbUsername} \
  ParameterKey=dbPassword,ParameterValue=${dbPassword} \
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
