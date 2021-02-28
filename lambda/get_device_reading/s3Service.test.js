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

const mockS3Instance = {
  getObject: jest.fn().mockReturnValueOnce(mockResponse)
};

jest.mock('aws-sdk', () => {
  return { S3: jest.fn(() => mockS3Instance) };
});

describe('S3 Service', () => {
  beforeEach(() => {
    jest.restoreAllMocks();
  });

  it('should GET S3 object correctly', async () => {
    const actual = await getObject('bucket-name', 'bucket-key');
    expect(actual).toEqual(mockResponse);
    expect(mockS3Instance.getObject).toBeCalledWith({ Bucket: 'bucket-name', Key: 'bucket-key' });
  });
});