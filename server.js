const express = require('express');
const bodyParser = require('body-parser')
const path = require('path');
const app = express();
const staticPath = __dirname + "/client/build";
app.use(express.static(staticPath));

app.get('/ping', function (req, res) {
 return res.send('pong');
});

app.get('/', function (req, res) {
  res.sendFile(path.join(__dirname, 'build', 'index.html'));
});

app.get("*", (request, response) =>
  response.sendFile(path.resolve(staticPath, "index.html"))
);

let port = process.env.PORT || 8080;

let server = app.listen(port, function() {
  console.log(`listening on port ${port}`);
});