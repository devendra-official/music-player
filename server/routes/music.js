const express = require('express')
const verifyToken = require('../middleware/token_verify')
const pool = require('../database/connection')

const router = express.Router();

router.post("/upload", verifyToken, async (req, res) => {
    try {
        const { name, imageurl, musicurl, artist, movie, color } = req.body;

        const insert = await pool.query('INSERT INTO musics(name,imageurl,musicurl,artist,movie,color,email) VALUES($1,$2,$3,$4,$5,$6,$7)',
            [name, imageurl, musicurl, artist, movie, color, req.email]);

        if (insert.rowCount == 1) {
            return res.status(201).json({ "msg": "uploaded successfully" })
        }
        return res.json({ "msg": "failed to upload your music" })
    } catch (e) {
        return res.status(500).json({ "msg": e.toString() })
    }
})

router.get("/list", verifyToken, async (req, res) => {
    try {
        const songs = await pool.query('SELECT * FROM musics WHERE email=$1 ORDER BY dt_uploaded DESC', [req.email]);
        return res.json(songs.rows);
    } catch (e) {
        return res.status(500).json({ "msg": e.toString() })
    }
})

module.exports = router;
