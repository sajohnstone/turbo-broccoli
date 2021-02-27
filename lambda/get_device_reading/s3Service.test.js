const aws = require('aws-sdk');
const s3 = new aws.S3(); 
const { getObject } = require('./s3Service')

jest.mock('aws-sdk')

describe('s3Service getObject', () => {
  beforeEach(() => {
    const s3GetObjectPromise = jest.fn().mockReturnValue({
      promise: jest.fn().mockResolvedValue({
        Parameter: {
          Name: 'NAME',
          Type: 'SecureString',
          Value: 'VALUE',
          Version: 1,
          LastModifiedDate: 1546551668.495,
          ARN: 'arn:aws:ssm:ap-southeast-2:123:NAME'
        }
      })
    })

    aws.S3.mockImplementation(() => ({
      getObject: s3GetObjectPromise
    }))
  })

  /*
  test.only('my only true test', () => {
    expect(1 + 1).toEqual(2);
  });
  */

  test('it should get value from S3', async () => {
    expect.assertions(1)
    await expect(getObject('NAME','VALUE')).resolves.toBe('VALUE')
  })
})
