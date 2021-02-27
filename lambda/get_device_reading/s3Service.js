'use strict';

const aws = require('aws-sdk');

exports.getObject = async (name, key) => {
  const s3 = new aws.S3(); 
  const params = {
      Bucket: name, // your bucket name,
      Key: key // path to the object you're looking for
  }

  const result = await s3.getObject(params).promise()
  console.log(JSON.stringify(result));
  return result.Parameter.Value

  /*
  s3.getObject(getParams, function(err, data) {
      // Handle any error and exit
      if (err)
          return err;

    // No error happened
    // Convert Body from a Buffer to a String

    return data.Body.toString('utf-8'); // Use the encoding necessary
  });
  */
}
