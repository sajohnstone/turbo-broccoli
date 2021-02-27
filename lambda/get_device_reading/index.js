exports.handler = async function(event, context) {
  console.log("event: " + JSON.stringify(event, null, 2))
  console.log("context: " + JSON.stringify(context, null, 2))

  let response = {}
  if (parseInt(event.id) >= 1) {
    response = {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Hello world',
        input: event,
      }),
    };
  }
  else {
    response = {
      statusCode: 500,
      body: JSON.stringify({
        message: 'Internal server error'
      }),
    };
  }

  return response;
};





