# Hosted Zone VPC Associations

```bash
SOURCE_PROFILE=mobile-dev
SOURCE_REGION=us-east-1
SOURCE_HOSTEDZONE=ZQ99JQ2PFYF70

TARGET_PROFILE=fleet-dev
TARGET_REGION=us-east-1
TARGET_VPC=vpc-3172eb4a

# create the authorization on the account where the hosted zone resides
#aws route53 create-vpc-association-authorization --hosted-zone-id Z2YBJK01WYA7K --vpc '{"VPCRegion": "us-east-1", "VPCId": "vpc-0b612e7adde4e6a77"}' --profile core-prod --region us-east-1
aws route53 create-vpc-association-authorization --hosted-zone-id ${SOURCE_HOSTEDZONE} --vpc '{"VPCRegion": "${TARGET_REGION}", "VPCId": "${TARGET_VPC}"}' --profile ${SOURCE_PROFILE} --region ${SOURCE_REGION}

# verify auth was created
#aws route53 list-vpc-association-authorizations --hosted-zone-id Z2YBJK01WYA7K --profile core-prod --region us-east-1
aws route53 list-vpc-association-authorizations --hosted-zone-id ${SOURCE_HOSTEDZONE} --profile ${SOURCE_PROFILE} --region ${SOURCE_REGION}

# associate the hosted zone to the VPC from the VPC's account
#aws route53 associate-vpc-with-hosted-zone --hosted-zone-id Z2YBJK01WYA7K --vpc '{"VPCRegion": "us-east-1", "VPCId": "vpc-0b612e7adde4e6a77"}' --profile mobile-dev --region us-east-1
aws route53 associate-vpc-with-hosted-zone --hosted-zone-id ${SOURCE_HOSTEDZONE} --vpc '{"VPCRegion": "${TARGET_REGION}", "VPCId": "${TARGET_VPC}"}' --profile ${TARGET_PROFILE} --region ${TARGET_REGION}

# remove the authorization
#aws route53 delete-vpc-association-authorization --hosted-zone-id Z2YBJK01WYA7K --vpc '{"VPCRegion": "us-east-1", "VPCId": "vpc-0b612e7adde4e6a77"}' --profile core-prod --region us-east-1
aws route53 delete-vpc-association-authorization --hosted-zone-id ${SOURCE_HOSTEDZONE} --vpc '{"VPCRegion": "${TARGET_REGION}", "VPCId": "${TARGET_VPC}"}' --profile ${SOURCE_PROFILE} --region ${SOURCE_REGION}

# verify auth was deleted
#aws route53 list-vpc-association-authorizations --hosted-zone-id Z2YBJK01WYA7K --profile core-prod --region us-east-1
aws route53 list-vpc-association-authorizations --hosted-zone-id ${SOURCE_HOSTEDZONE} --profile ${SOURCE_PROFILE} --region ${SOURCE_REGION}
```

