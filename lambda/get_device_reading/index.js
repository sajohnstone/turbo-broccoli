const { getObject } = require('./s3Service')
const { csvJSON } = require('./csvToJson')
const fs = require('fs');

const getJson = async function() {
  let csvdata = await getObject('csv-store-default', 'timezone');
  fs.writeFileSync('/tmp/data.csv', csvdata.Body);
  const rdata = fs.readFileSync('/tmp/data.csv', 'utf8');
  const jsonData = await csvJSON(rdata);
  return JSON.parse(jsonData);
}

const findByID = async function(jsonData, id) {
  let arrFound = jsonData.filter(function(item) {
    return item.id == id;
  });
  if (arrFound.length == 0) return null;
  return arrFound[0];
}

exports.handler = async function(event, context) {
  console.log("event: " + JSON.stringify(event, null, 2))
  console.log("context: " + JSON.stringify(context, null, 2))

  let request_id = parseInt(event.pathParameters.id);
  let deviceData = await getJson();
  let device = await findByID(deviceData, request_id);

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