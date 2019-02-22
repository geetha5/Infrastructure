##
# kinesis_encryption.py
# written by Diego Gutierrez <diego.gutierrez@wexinc.com>
# This is a lambda function backing for a custom cloudformation
# resource for setting up server-side encryption for kinesis
#
##

import boto3
import logging
import requests
import json

# setup logging 
log = logging.getLogger()
log.setLevel(logging.DEBUG)

##
# send_cfn_response(event, context, status)
# This will format and send the cloudformation response
##
def send_cfn_response(event, context, status, reason=None, data=None):
    if reason is None:
        reason = 'See the details in CloudWatch Log Stream: ' + context.log_stream_name

    if data is None:
        data = { status: 'resource ' + event['RequestType'] }

    response_body = {
        'Status': status,
        'Reason': reason,
        'PhysicalResourceId': context.log_stream_name,
        'StackId': event['StackId'],
        'RequestId': event['RequestId'],
        'LogicalResourceId': event['LogicalResourceId'],
        'Data': data
    }

    log.debug('ResponseBody: ' + json.dumps(response_body))

    # only send the response if the LocalMock is not present in the event
    # LocalMock is a trigger that the lambda is being run locally and there is
    # no CFN to respond back to
    if 'LocalMock' not in event:
        try:
            req = requests.put(event['ResponseURL'], data=json.dumps(response_body))
            if req.status_code != 200:
                print(req.text)
                raise Exception('Received non 200 response while sending response to CFN.')
        except requests.exceptions.RequestException as e:
            print(e)
            raise

##
# validate_config_properties(event)
# This will validate the required properties are present,
# it will return an error reason to fail the resource
##
def validate_config_properties(event):
    properties = event['ResourceProperties']
    config_keys = ['KmsKeyId', 'KinesisStreamName', 'DesiredState']

    # Loop through the required properties and validate they are present
    for key in config_keys:
        if properties[key] is None:
            log.error('No %s property on event %s', key, event)
            return "No required property %s" % (key)

        else: 
            log.debug('property %s is set to %s', key, properties[key])
    
    # Validate the DesiredState property is either encrypted or decrypted
    if (properties['DesiredState'].lower() != 'encrypted') and (properties['DesiredState'].lower() != 'decrypted'):
        log.error('DesiredState property must be either encrypted or decrypted')
        return "DesiredState property must be either encrypted or decrypted"

    else:
        log.debug('DesiredState is %s', properties['DesiredState'])

##
# validate_kinesis_stream(event, kinesis)
# This will check if the kinesis stream exists,
# it will return an error if it does not exist
##
def validate_kinesis_stream(event, kinesis):
    properties = event['ResourceProperties']

    try:
        resp = kinesis.describe_stream(StreamName=properties['KinesisStreamName'])
    except:
        log.error('No Kinesis Stream %s exists', properties['KinesisStreamName'])
        return "No Kinesis Stream %s exists" % (properties['KinesisStreamName'])

##
# validate_kms_key(event, kms)
# This will check if the kms key exists,
# it will return an error if it does not exist
##
def validate_kms_key(event, kms):
    properties = event['ResourceProperties']

    try:
        res = kms.describe_key(KeyId=properties['KmsKeyId'])
    except:
        log.error('No KMS key %s exists in the account', properties['KmsKeyId'])
        return "No KMS key with ID %s exists" % (properties['KmsKeyId'])

##
# validate_properties(event)
# This is a wrapper that will run all
# validation and act as a single call
# point
## 
def validate_properties(event, kinesis, kms):
    config_errors = validate_config_properties(event)
    if config_errors:
        return config_errors

    kinesis_errors = validate_kinesis_stream(event, kinesis)
    if kinesis_errors:
        return kinesis_errors

    kms_errors = validate_kms_key(event, kms)
    if kms_errors:
        return kms_errors

##
# encrypt_update_key(event, encryptType)
# This is a helper to encrypt or update the key
# for a kinesis stream and send the response
##
def encrypt_update_key(event, context, encrypt_type, kinesis):
    properties = event['ResourceProperties']
    
    if encrypt_type == 'create':
        fail_message = 'encrypt'
        success_message = 'encrypted'
    else:
        fail_message = 'update encryption key on'
        success_message = 'updated encryption key on'

    try:
        resp = kinesis.start_stream_encryption(
            StreamName=properties['KinesisStreamName'],
            EncryptionType='KMS',
            KeyId=properties['KmsKeyId']
        )
    except:
        # respond fail and log error for an exception
        log.error('Unable to %s kinesis stream %s with key %s', fail_message, properties['KinesisStreamName'], properties['KmsKeyId'])
        send_cfn_response(event, context, 'FAILED')

    # respond success if the encryption call succeeded
    log.info('successfully %s kinesis stream %s with key %s', success_message, properties['KinesisStreamName'], properties['KmsKeyId'])
    send_cfn_response(event, context, 'SUCCESS')

##
# decrypt(event)
# This is a helper to decrypt the Kinesis Stream
# and send the response
##
def decrypt(event, context, kinesis):
    properties = event['ResourceProperties']

    try:
        resp = kinesis.stop_stream_encryption(
            StreamName=properties['KinesisStreamName'],
            EncryptionType='KMS',
            KeyId=properties['KmsKeyId']
        )

        # respond with success if decryption was successful
        log.info('successfully decrypted kinesis stream %s', properties['KinesisStreamName'])
        send_cfn_response(event, context, 'SUCCESS')
    except:
        # respond with failure and log error
        log.error('Unable to unencrypt Kinesis Stream %s', properties['KinesisStreamName'])
        send_cfn_response(event, context, 'FAILED')


##
# create_kinesis_encryption(event, context)
# This is the function for the create action of
# cloudformation
##
def create_kinesis_encryption(event, context, kinesis):
    properties = event['ResourceProperties']

    log.debug('Executing create on stack: %s resource: %s', event['StackId'], event['LogicalResourceId'])

    # If the Desired state is for the stream to be encyrpted try to encrypt
    if properties['DesiredState'].lower() == 'encrypted':
        # Since this is a new stack Kinesis wont be encrypted so we will just need to 
        # set up the encryption with the proper key
        log.info('Attempting to encrypt kinesis stream %s', properties['KinesisStreamName'])
        encrypt_update_key(event, context, 'create', kinesis)

    # Since the stack is just being created if the DesiredState is set to decrypted there is 
    # no action required.
    else:
        # respond with success since there is nothing to be done
        log.info('DesiredState is decrypted and the Kinesis Stream %s is already decrypted', properties['KinesisStreamName'])
        send_cfn_response(event, context, 'SUCCESS')


##
# update_kinesis_encryption(event, context)
# This is the function for the update action of
# cloudformation
##
def update_kinesis_encryption(event, context, kinesis):
    properties = event['ResourceProperties']

    log.debug('Executing update on stack: %s resource: %s', event['StackId'], event['LogicalResourceId'])    

    # get current kms key and encryption status
    stream_descrip = kinesis.describe_stream(
        StreamName=properties['KinesisStreamName']
    )

    stream_current_encryption = stream_descrip['StreamDescription']['EncryptionType']
    if stream_current_encryption == 'KMS':
        stream_current_key = stream_descrip['StreamDescription']['KeyId']

    # Case 1: The DesiredState is to be encrypted
    if properties['DesiredState'].lower() == 'encrypted':
        # SubCase 1: The Stream is encrypted
        if stream_current_encryption == 'KMS':

            # if the key is the current key,  success
            if properties['KmsKeyId'] == stream_current_key:
                send_cfn_response(event, context, 'SUCCESS')

            # else change the key used to encrypt the stream
            else:
                log.info('Changing KMS key for kinesis stream %s to %s from %s', properties['KinesisStreamName'], stream_current_key, properties['KmsKeyId'])
                encrypt_update_key(event, context, 'update', kinesis)

        # SubCase 2: The Stream is not encrypted
        else:
            # set up encryption for the stream
            log.info('kinesis stream %s is not encrypted, encrypt')
            encrypt_update_key(event, context, 'create', kinesis)

    # Case 2: The DesiredState is to be dencrypted
    else:
        # SubCase 1: The Stream is encrypted
        if stream_current_encryption == 'KMS':
            
            log.info('DesiredState is decrypted and the kinesis stream %s is encrypt, decrypting', properties['KinesisStreamName'])
            decrypt(event, context, kinesis)
            
        # SubCase 2: The Stream is not encrypted
        else:
            # respond success since there is nothing to be done
            log.info('DesiredState is decrypted and the Kinesis Stream %s is already decrypted', properties['KinesisStreamName'])
            send_cfn_response(event, context, 'SUCCESS')

##
# delete_kinesis_encryption(event, context)
# This is the function for the delete action of
# cloudformation
##
def delete_kinesis_encryption(event, context):
    
    log.debug('Executing delete on stack: %s resource: %s', event['StackId'], event['LogicalResourceId'])
    
    # if the stack is deleting just respond with success
    # since we don't care about encryption status when deleting
    send_cfn_response(event, context, 'SUCCESS')

##
# handler(event, context)
# this is entry point handler that will dispatch to the correct
# function
##
def handler(event, context):

    # set session profile if passed for testing
    if 'SessionProfile' in event:
        session = boto3.Session(profile_name=event['SessionProfile'])
    else:
        session = boto3.Session()

    kinesis = session.client('kinesis')
    kms = session.client('kms')

    # check for any config errors and respond with fail
    config_error = validate_properties(event, kinesis, kms)
    if config_error:
        send_cfn_response(event, context, 'FAIL', config_error)

    # Dispatch the proper request type function
    if event['RequestType'] == "Create":
        create_kinesis_encryption(event, context, kinesis)
    elif event['RequestType'] == "Delete":
        delete_kinesis_encryption(event, context)
    elif event['RequestType'] == "Update":
        update_kinesis_encryption(event, context, kinesis)
    else:
        log.error('unknown request type %s', event.RequestType)
        send_cfn_response(event, context, 'FAILED', 'Unknown Request Type')
    

