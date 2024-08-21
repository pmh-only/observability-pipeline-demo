const express = require('express')
const app = express()

app.get('/healthz', (req, res) => {
  res.send({
    success: true
  })
})

app.get('/api/v1/color', (req, res) => {
  res.send({
    color: ['red', 'orange', 'green', 'blue'][Math.floor(Math.random() * 4)]
  })
})

app.listen(8080, () =>
  console.log('Server is now on http://localhost:8080'))
