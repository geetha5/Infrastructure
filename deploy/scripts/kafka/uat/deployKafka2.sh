type=$1
version=$2

templateUrl="https://s3.amazonaws.com/wex-mobile-devops/projects/kafka/dev/${version}/cloudformation/kafka-broker-clustered.cf.json"

# Parameters 

# Common Zookeepr 
environment="stage"
vpcStackName="mobile-stage-vpc"
kafkaCommonStackName="kafka-common-stage"
clusterName="kafka"
enableSsh="yes"
devopsBucket="wex-mobile-devops"
instanceKeyPair="mwd-devops"
amiId="ami-e1bd9f9b"
instanceType="t3.large"
kafkaInfrastructureVersion="dev/${version}"
ansibleRoleVersion="dev/2.2.0_20180731-150600"
logVolumeSize=100
deploymentId="asdjlkajsdslkjasdlk"
asgActionLambdaStackName="none"

# Instance
kafkaBrokerId=2
instanceAz="A"
kafkaBootstrapServer="yes"
dnsName="kafka-bootstrap-3.stage.intwexmobile.net"

stackName="kafka-broker-${clusterName}-${kafkaBrokerId}-${environment}"

if [[ "${type}" == "create" ]]; then

  aws cloudformation create-stack --region us-east-1 --stack-name ${stackName} --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kafkaCommonStackName,ParameterValue=${kafkaCommonStackName} \
  ParameterKey=clusterName,ParameterValue=${clusterName} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=kafkaInfrastructureVersion,ParameterValue=${kafkaInfrastructureVersion} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=logVolumeSize,ParameterValue=${logVolumeSize} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  ParameterKey=kafkaBrokerId,ParameterValue=${kafkaBrokerId} \
  ParameterKey=instanceAz,ParameterValue=${instanceAz} \
  ParameterKey=asgActionLambdaStackName,ParameterValue=${asgActionLambdaStackName} \
  ParameterKey=kafkaBootstrapServer,ParameterValue=${kafkaBootstrapServer} \
  ParameterKey=dnsName,ParameterValue=${dnsName} \
  --output text --profile mobile-stage

else 

  aws cloudformation update-stack --region us-east-1 --stack-name ${stackName} --template-url ${templateUrl} \
  --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters \
  ParameterKey=environment,ParameterValue=${environment} \
  ParameterKey=vpcStackName,ParameterValue=${vpcStackName} \
  ParameterKey=kafkaCommonStackName,ParameterValue=${kafkaCommonStackName} \
  ParameterKey=clusterName,ParameterValue=${clusterName} \
  ParameterKey=enableSsh,ParameterValue=${enableSsh} \
  ParameterKey=devopsBucket,ParameterValue=${devopsBucket} \
  ParameterKey=amiId,ParameterValue=${amiId} \
  ParameterKey=instanceType,ParameterValue=${instanceType} \
  ParameterKey=instanceKeyPair,ParameterValue=${instanceKeyPair} \
  ParameterKey=kafkaInfrastructureVersion,ParameterValue=${kafkaInfrastructureVersion} \
  ParameterKey=ansibleRoleVersion,ParameterValue=${ansibleRoleVersion} \
  ParameterKey=logVolumeSize,ParameterValue=${logVolumeSize} \
  ParameterKey=deploymentId,ParameterValue=${deploymentId} \
  ParameterKey=kafkaBrokerId,ParameterValue=${kafkaBrokerId} \
  ParameterKey=instanceAz,ParameterValue=${instanceAz} \
  ParameterKey=asgActionLambdaStackName,ParameterValue=${asgActionLambdaStackName} \
  ParameterKey=kafkaBootstrapServer,ParameterValue=${kafkaBootstrapServer} \
  ParameterKey=dnsName,ParameterValue=${dnsName} \
  --output text --profile mobile-stage

fi 
