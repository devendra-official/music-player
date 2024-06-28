const jwt = require('jsonwebtoken')
const fs = require('fs')
const pool = require("../database/connection")
require('dotenv').config()

const verifyToken = async (req, res, next) => {
    try {
        const token = req.header('x-auth-token');

        if (!token) {
            return res.status(401).json({ message: 'Access denied, No token provided.' });
        }

        const publicKey = fs.readFileSync(process.env.publicKeyPath)
        decoded = jwt.verify(token, publicKey)
        const user = await pool.query('SELECT email FROM users WHERE uid=$1 LIMIT 1', [decoded.uid]);
        if (user.rowCount == 1) {
            req.email = user.rows[0].email;
            return next()
        }
        return res.status(401).json({ "msg": "user not found" })
    } catch (e) {
        return res.status(401).json({ "msg": "token verification failed,Please Login and try again" })
    }
}

module.exports = verifyToken;