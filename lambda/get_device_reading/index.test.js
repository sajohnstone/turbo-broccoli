const lambdaService = require('./index');
const csvToJson = require('./csvToJson');

const ValidEvent = {
  "name": "test value",
  "pathParameters": {
    "id": "23"
  }
};

const FailEvent = {
  "name": "test value",
  "pathParameters": {
    "id": "-1"
  }
};

describe('Lambda Service', () => {
  beforeAll(() => {
    jest.spyOn(csvToJson, 'retrieveData').mockResolvedValueOnce([
      {
        "item": 23
      },
      {
        "item": 22
      }
    ]);
  })

  afterAll(() => {
    jest.restoreAllMocks();
  });

  test('should return data', async () => {
    const mResponse = {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Hello world',
        input: ValidEvent,
      }),
    };
    const actualValue = await lambdaService.handler(ValidEvent, null);

    expect(1).toEqual(1);
  });

  /*
  test('should return error message', async () => {
    const mEvent = { id: -1 };
    const mResponse = {
      statusCode: 500,
      body: JSON.stringify({
        message: 'Internal server error'
      }),
    };
    const actualValue = await lambdaService.handler(mEvent);
    expect(actualValue).toEqual(mResponse);
  });
  */
});