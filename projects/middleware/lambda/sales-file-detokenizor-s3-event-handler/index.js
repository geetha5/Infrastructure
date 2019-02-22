// dependencies
const util = require("util");
const request = require("request");

exports.handler = (event, context, callback) => {
    // Read options from the event.
    console.log("Reading options from event:\n", util.inspect(event, {depth: 5}), "\n\n");
    const srcBucket = event.Records[0].s3.bucket.name;
    // Object key may have spaces or unicode non-ASCII characters.
    // noinspection JSDeprecatedSymbols
    const srcKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));
    let parts = srcKey.split("/");
    let filename = parts.pop();
    let path = parts.reduce(x + "/");

    console.log("srcBucket: ", srcBucket);
    console.log("srcFile: ", srcKey);
    console.log("fileName: ", filename);
    console.log("path in S3: ", path);

    // Stream the transformed image to a different S3 bucket.
    let options = {
        host: "salesfiledetokenizer.dit.dev.wexfleetweb.com",
        port: 5000,
        path: "/process/shell-file"
    };

    // request.get(options, (err, res) => {
    //     if (err) {
    //         return console.log(err);
    //     }

        callback(null, "Success" === res.body ? "SUCCESS" : "FAILED");
    // });
};
