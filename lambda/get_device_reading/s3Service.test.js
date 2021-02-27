const aws = require('aws-sdk');
const s3 = new aws.S3(); 
const { getObject } = require('./s3Service')
const mockResponse = {
  "AcceptRanges": "bytes",
  "LastModified": "2021-02-27T15:22:36.000Z",
  "ContentLength": 372,
  "ETag": "\"85262fc380f9d76ec0f9845479efda57\"",
  "ContentType": "binary/octet-stream",
  "Metadata": {},
  "Body": {
    "type": "Buffer",
    "data": [
      105,
      100]
  }
}

jest.mock('aws-sdk')

describe('s3Service getObject', () => {
  beforeEach(() => {
    const s3GetObjectPromise = jest.fn().mockReturnValue({
      promise: jest.fn().mockResolvedValue(mockResponse)
    })

    aws.S3.mockImplementation(() => ({
      getObject: s3GetObjectPromise
    }))
  })

  test('it should get value from S3', async () => {
    expect.assertions(1)
    await expect(getObject('NAME','VALUE')).resolves.toBe(mockResponse)
  })
})
