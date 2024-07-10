const { Pool } = require('pg')

const pool = new Pool({
    user: 'postgres',
    host: '127.0.0.1',
    database: 'Music Player',
    password: 'postgres',
    port: 5432,
})

module.exports = pool;