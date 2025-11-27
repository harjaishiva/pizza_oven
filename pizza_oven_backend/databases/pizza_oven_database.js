const mysql = require('mysql2');
require('dotenv').config();

const pool = mysql.createPool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: false
});

pool.getConnection((err)=>{
    if(err){
        console.log(`ERROR WHILE CONNECTING USER DATABASE : ${err}`);
    }
    else{
        console.log("USER DB connected successfully");
    }
});

module.exports = pool.promise();