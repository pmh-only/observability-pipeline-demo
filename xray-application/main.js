const AWSXRay = require('aws-xray-sdk-core')
const xrayExpress = require('aws-xray-sdk-express')
const express = require('express')
const app = express()

app.use(xrayExpress.openSegment('defaultName'))

app.get('/healthz', (req, res) => {
  const segment = AWSXRay.getSegment()
  segment.addAnnotation('page', 'healthz')

  res.send({
    success: true
  })
})

app.get('/api/v1/color', (req, res) => {
  const segment = AWSXRay.getSegment()
  segment.addAnnotation('page', 'directory')

  res.send({
    color: ['red', 'orange', 'green', 'blue'][Math.floor(Math.random() * 4)]
  })
})

app.use(xrayExpress.closeSegment())
app.listen(8080, () =>
  console.log('Server is now on http://localhost:8080'))

process.on('SIGINT', () => {
  process.exit(0)
})

process.on('SIGTERM', () => {
  process.exit(0)
})
