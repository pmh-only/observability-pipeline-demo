const { STSClient, GetCallerIdentityCommand } = require("@aws-sdk/client-sts")
const express = require('express')
const app = express()

const client = new STSClient({
  region: 'ap-northeast-2'
})

app.get('/healthz', async (req, res) => {
  const command = new GetCallerIdentityCommand({});
  const data = await client.send(command);

  res.send({
    success: true,
    data
  })
})

app.get('/api/v1/color', (req, res) => {
  res.send({
    color: ['red', 'orange', 'green', 'blue'][Math.floor(Math.random() * 4)]
  })
})

app.listen(8080, () =>
  console.log('Server is now on http://localhost:8080'))
