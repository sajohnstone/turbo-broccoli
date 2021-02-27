const lambdaService = require('./index')

describe('lambdaService', () => {
  beforeEach(() => {
    jest.restoreAllMocks();
  });

  test('should return data', async () => {
    const mEvent = { id: 1 };
    const mResponse = {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Hello world',
        input: mEvent,
      }),
    };
    const actualValue = await lambdaService.handler(mEvent);
    expect(actualValue).toEqual(mResponse);
  });

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
});