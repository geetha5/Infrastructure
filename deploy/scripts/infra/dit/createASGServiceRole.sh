#!/bin/bash

aws kms create-grant --profile mobile-dev --region us-east-1 --key-id arn:aws:kms:us-east-1:518554605247:key/7114a857-a3d5-421d-b61f-178f21b8f381 --grantee-principal arn:aws:iam::518554605247:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling_MWD --operations "Encrypt" "Decrypt" "ReEncryptFrom" "ReEncryptTo" "GenerateDataKey" "GenerateDataKeyWithoutPlaintext" "DescribeKey" "CreateGrant"

#{
#    "GrantToken": "AQpAZTZmYjE0NTAzZTA4MzE1ZmY0NGJjYWE2MTM0M2RjY2ZhNjAyYjc1OGRkZGQ0MjhhMTdmZWQyMTdkNjBiODQyNyKWAgEBAgB45vsUUD4IMV_0S8qmE0Pcz6YCt1jd3UKKF_7SF9YLhCcAAADtMIHqBgkqhkiG9w0BBwaggdwwgdkCAQAwgdMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMMM7X-2gLuS7bNgIFAgEQgIGl3Qb_Ax1VyIA2_T9RpBdv9H7DXFz5d0BaGn0YncARn5k566LuP44caPLWoqQ0jEXI-1_keKug4eULK72IweBGzuUSTxoXanREr4rduUXl_oP9GXGk9L6rrqxz2oFnidq3QC4cpbP2KY4DdGtZdwufwIU0gzN06XRh45cubJnMlhppbVX_hvMERAtpcxMaXRM3qp3Y0wpdDg4rPWdKFJYOt5yw-lF1KiD6SuC4BpxsHQAF1j5_YCvtyyldtZeU9pgofyg3FFjzGw",
#    "GrantId": "fa4ae0b8069c6c1d0005d63e7f602bedcb295db59794f698287f28371458f31b"
#}
