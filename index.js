const express = require('express')
const app = express()
const port = process.env.PORT || 4000

app.get('/', (req, res) => {
	res.status(200).json({ msg: 'Rootless mode environment' })
})

app.listen(port, () => console.info(`Server listening on port ${port}`))
