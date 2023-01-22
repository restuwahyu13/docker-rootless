const express = require('express')
const app = express()
const port = process.env.NODE_ENV || 3000

app.get('/', (req, res) => {
	res.status(200).json({ msg: 'Rootless mode environment' })
})

app.listen(port)
