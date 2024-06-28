const express = require("express")
const pool = require('../database/connection')
const router = express.Router()
const selectId = require("../utils/generateuid")
const jwt = require('jsonwebtoken');
const fs = require('fs')
const bcrypt = require('bcrypt');
require('dotenv').config()

router.post('/add-user', async (req, res) => {
    try {
        const { name, email, password } = req.body;

        const generateId = selectId();
        let uids = [];

        const db_uids = await pool.query('SELECT uid FROM users');
        db_uids.rows.map((uid) => uids.push(uid));
        const guid = generateId(uids);

        const isExist = await pool.query('SELECT email FROM users WHERE email=$1 LIMIT 1', [email]);
        if (isExist.rowCount == 1) {
            return res.status(400).json({ "msg": "email has already been created." })
        }
        const hash = bcrypt.hashSync(password, 10);
        const result = await pool.query(
            'INSERT INTO users (uid, name, email, password) VALUES ($1, $2, $3, $4)',
            [guid, name, email, hash]
        );

        if (result.rowCount === 1) {
            return res.status(201).json({ "msg": `user ${name} created` })
        }
        return res.status(400).json({ "msg": "failed to create new user" })
    } catch (e) {
        return res.status(500).json({ "msg": e.toString() });
    }
});

router.post("/signin", async (req, res) => {
    try {
        const { email, password } = req.body;
        const result = await pool.query('SELECT uid,name,email,password,dt_created FROM users WHERE email=$1 LIMIT 1', [email])

        if (result.rowCount == 0) {
            return res.status(400).json({ "msg": "email not found" });
        }
        if (bcrypt.compareSync(password, result.rows[0].password)) {
            const privateKey = fs.readFileSync(process.env.privateKeyPath, 'utf-8')

            const token = jwt.sign({ uid: result.rows[0].uid }, privateKey, { algorithm: 'RS256' });
            return res.status(200).json(
                {
                    "token": token,
                    "user": {
                        "name": result.rows[0].name,
                        "email": result.rows[0].email,
                        "created_at": result.rows[0].dt_created
                    }
                }
            )
        }
        if (result.rows[0].password != password) {
            return res.status(401).json({ "msg": "Wrong password" })
        }
        return res.status(401).json({ "msg": "something went wrong,please wait untill problem resolved" })
    } catch (e) {
        return res.status(500).json({ "msg": e.toString() });
    }
})

module.exports = router