const { getObject } = require('./s3Service')
const fs = require('fs');

const csvJSON = async (csv) => {
  let lines = csv.split("\n");
  let result = [];
  let headers = lines[0].split(",");

  for (let i = 1; i < lines.length; i++) {
    let obj = {};
    let currentline = lines[i].split(",");

    for (let j = 0; j < headers.length; j++) {
      obj[headers[j]] = currentline[j];
    }
    result.push(obj);
  }

  return JSON.stringify(result);
}

module.exports = {
  retrieveData: async (bucketname, key) => {
    let p = await getObject(bucketname, key);
    let csvdata = await p.promise();
    fs.writeFileSync('/tmp/data.csv', csvdata.Body);
    const rdata = fs.readFileSync('/tmp/data.csv', 'utf8');
    const jsonData = await csvJSON(rdata);
    return JSON.parse(jsonData);
  },
};


