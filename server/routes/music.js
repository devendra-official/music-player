const express = require('express')
const verifyToken = require('../middleware/token_verify')
const pool = require('../database/connection')

const router = express.Router();

router.post("/upload", verifyToken, async (req, res) => {
    try {
        const { name, imageurl, musicurl, artist, album, language } = req.body;

        const insert = await pool.query('INSERT INTO musics(name,imageurl,musicurl,artist,album,email,language) VALUES($1,$2,$3,$4,$5,$6,$7)',
            [name, imageurl, musicurl, artist, album, req.email, language]);

        if (insert.rowCount == 1) {
            return res.status(201).json({ "msg": "uploaded successfully" })
        }
        return res.json({ "msg": "failed to upload your music" })
    } catch (e) {
        return res.status(500).json({ "msg": "Internal server error" })
    }
})

router.get("/list-all", verifyToken, async (_, res) => {
    try {
        const songs = await pool.query('SELECT * FROM musics ORDER BY id DESC');
        return res.json(songs.rows);
    } catch (e) {
        return res.status(500).json({ "msg": "Internal server error" })
    }
})

router.get("/language", verifyToken, async (_, res) => {
    try {
        let languageResult = await pool.query('SELECT language, COUNT(language) AS total_songs FROM musics GROUP BY language ORDER BY total_songs DESC');
        let languages = languageResult.rows.map((language) => language.language);

        let songsByLanguage = {}
        songsByLanguage["languages"] = languages;
        for (let language of languages) {
            let songs = await pool.query('SELECT * FROM musics WHERE language=$1 ORDER BY id DESC', [language]);
            songsByLanguage[language] = songs.rows;
        }
        return res.json(songsByLanguage);
    } catch (e) {
        return res.status(500).json({ "msg": 'Internal server error' });
    }
});


router.post("/search", verifyToken, async (req, res) => {
    try {
        const { value } = req.body;
        if (value == '') {
            return res.json([]);
        }
        const songs = await pool.query('SELECT * FROM musics WHERE LOWER(name) LIKE LOWER($1) OR LOWER(album) LIKE LOWER($1)', [`%${value}%`]);
        return res.json(songs.rows);
    } catch (e) {
        return res.status(500).json({ "msg": "Internal server error" })
    }
})

module.exports = router;
