const aws = require('aws-sdk');
const elbv2 = new aws.ELBv2();

exports.handler = (event, context) => {
    console.log("REQUEST RECEIVED: " + JSON.stringify(event));

    // properties passed in via CF properties
    let props = event.ResourceProperties;
    //remove CF Resource needed goo
    delete props.ServiceToken;

    // console.log("\nParameters:\n", event.ResourceProperties)

    switch (event.RequestType) {
        case 'Create':
            elbv2.createListener(props, (err, data) => {
                if (err) {
                    console.log(err, err.stack);
                    sendResponse(event, context, "FAILED");

                } else {
                    let listener = data.Listeners.pop();
                    // console.log('Listener DATA', listener);

                    sendResponse(event, context, "SUCCESS", listener.ListenerArn, {
                        Arn: listener.ListenerArn,
                        Port: listener.Port,
                        Protocol: listener.Protocol
                    });
                }
            });
            break;

        case 'Update':
            elbv2.modifyListener(props, (err, data) => {
                if (err) {
                    console.log(err, err.stack);
                    sendResponse(event, context, "FAILED");

                } else {
                    let listener = data.Listeners.pop();
                    // console.log('Listener DATA', listener);

                    sendResponse(event, context, "SUCCESS", listener.ListenerArn, {
                        Arn: listener.ListenerArn,
                        Port: listener.Port,
                        Protocol: listener.Protocol
                    });
                }
            });
            break;

        case 'Delete':
            elbv2.deleteListener({ListenerArn: event.PhysicalResourceId}, (err, data) => {
                sendResponse(event, context, err ? "FAILED" : "SUCCESS");
            });
            break;

        default:
            sendResponse(event, context, "FAILED");

    }
    // "https://#{host}:443/#{path}?#{query}"

};

function sendResponse(event, context, responseStatus, physicalResourceId, responseData) {

    let responseBody = JSON.stringify({
        Status: responseStatus,
        Reason: "See the details in CloudWatch Log Stream: " + context.logStreamName,
        PhysicalResourceId: physicalResourceId || context.logStreamName,
        StackId: event.StackId,
        RequestId: event.RequestId,
        LogicalResourceId: event.LogicalResourceId,
        Data: responseData
    });

    console.log("RESPONSE BODY:\n", responseBody);

    const https = require("https");
    const url = require("url");

    const parsedUrl = url.parse(event.ResponseURL);
    const options = {
        hostname: parsedUrl.hostname,
        port: 443,
        path: parsedUrl.path,
        method: "PUT",
        headers: {
            "content-type": "",
            "content-length": responseBody.length
        }
    };

    console.log("SENDING RESPONSE...\n");

    let request = https.request(options, (response) => {
        console.log("STATUS: " + response.statusCode);
        console.log("HEADERS: " + JSON.stringify(response.headers));

        // Tell AWS Lambda that the function execution is done
        context.done();
    });


    request.on("error", (error) => {
        console.log("sendResponse Error:" + error);

        // Tell AWS Lambda that the function execution is done
        context.done();
    });

    // write data to request body
    request.write(responseBody);
    request.end();
}
