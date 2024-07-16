const express = require('express')
const userRoutes = require('./routes/users')
const musicRouter = require('./routes/music')

app = express()
app.use(express.json())
app.use('/users', userRoutes)
app.use('/music', musicRouter)

PORT = 8000

app.use((req, res, next) => {
    res.status(404).json({ "msg": "Not Found - The page you are looking for does not exist." });
});

app.listen(PORT, () => {
    console.log('Service running at http://0.0.0.0:' + PORT);
});