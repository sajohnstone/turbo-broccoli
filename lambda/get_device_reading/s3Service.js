const aws = require('aws-sdk');

exports.getObject = async (name, key) => {
  const s3 = new aws.S3(); 
  const params = {
      Bucket: name, // your bucket name,
      Key: key // path to the object you're looking for
  }

  const result = await s3.getObject(params);

  return result;
}
