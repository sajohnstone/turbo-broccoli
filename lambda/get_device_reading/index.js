const csvToJson = require('./csvToJson');

const findByID = async function (jsonData, id) {
  let arrFound = jsonData.filter(function (item) {
    return item.id == id;
  });
  if (arrFound.length == 0) return null;
  return arrFound[0];
}

exports.handler = async function (event, context) {
  console.log("event: " + JSON.stringify(event));
  console.log("context: " + JSON.stringify(context));

  let request_id = parseInt(event.pathParameters.id);


  let deviceData = await csvToJson.retrieveData('csv-store-default', 'timezone');
  console.log("deviceData: " + JSON.stringify(deviceData));
  let device = await findByID(deviceData, request_id);
  console.log("device: " + JSON.stringify(device));

  let response = {}
  if (device != null) {
    response = {
      statusCode: 200,
      body: JSON.stringify(device),
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