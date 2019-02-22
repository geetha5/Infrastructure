##
# ssm_secure_lookup.py
# Written by Diego Gutierrez <diego.gutierrez@wexinc.com>
# This will do a lookup of an encrypted parameter in parameter store
# and will return the value for later use in the template
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

    log.debug('ResponseBody: '+ json.dumps(response_body))

    # only send the response if the LocalMock is not present in the event
    # LocalMock is a trigger that the lambda is being run locally and there is
    # no CFN to respond back to
    if 'LocalMock' not in event:
        try:
            req = requests.put(event['ResponseURL'], data=json.dumps(response_body))
            if req.status_code != 200:
                print req.text
                raise Exception('Received non 200 response while sending response to CFN.')
        except requests.exceptions.RequestException as e:
            print e
            raise


##
# handler(event, context)
# This is the entry point handler that will dispatch to the correct
# function
##
def handler(event, context):

    # set session profile for testing
    if 'SessionProfile' in event:
        session = boto3.Session(profile_name=event['SessionProfile'])
    else:
        session = boto3.Session()

    ssm = session.client('ssm')


