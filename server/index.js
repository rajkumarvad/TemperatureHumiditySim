const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const moment = require('moment');
const axios = require('axios'); // For making HTTP requests

// Create a new Express application
const app = express();
const port = 9000;

// Middleware to parse JSON bodies
app.use(bodyParser.json());

// Create a connection to the MySQL database
const db = mysql.createConnection({
    host: 'localhost',
    user: 'your-username',
    password: 'your-password',
    database: 'sensor_data'
});

// Connect to the database
db.connect((err) => {
    if (err) {
        throw err;
    }
    console.log('Connected to database');
});

// Endpoint to store temperature and humidity data
app.post('/temperature-humidity', (req, res) => {
    const { temperature, humidity } = req.body;
    const dateTime = moment().format('YYYY-MM-DD HH:mm:ss');

    const query = 'INSERT INTO readings (temperature, humidity, date_time) VALUES (?, ?, ?)';
    db.query(query, [temperature, humidity, dateTime], (err, result) => {
        if (err) {
            return res.status(500).send(err);
        }
        res.send('Data inserted successfully');
    });
});

// Endpoint to fetch the latest temperature and humidity data
app.get('/latest', (req, res) => {
    const query = 'SELECT * FROM readings ORDER BY date_time DESC LIMIT 1';

    db.query(query, (err, results) => {
        if (err) {
            return res.status(500).send(err);
        }
        if (results.length === 0) {
            return res.status(404).send('No data found');
        }
        res.json(results[0]);
    });
});

// Endpoint to fetch records based on the current date and time
app.get('/readings', (req, res) => {
    const query = 'SELECT * FROM readings WHERE date_time = ?';
    const currentDateTime = moment().format('YYYY-MM-DD HH:mm:ss');

    db.query(query, [currentDateTime], (err, results) => {
        if (err) {
            return res.status(500).send(err);
        }
        res.json(results);
    });
});

// Endpoint to handle /START message from the Flutter app
app.get('/START', async (req, res) => {
    try {
        await axios.get('http://embedded.co.in:8000/START');
        res.send('START message sent to simulator');
    } catch (error) {
        res.status(500).send('Failed to send START message to simulator');
    }
});

// Endpoint to handle /STOP message from the Flutter app
app.get('/STOP', async (req, res) => {
    try {
        await axios.get('http://embedded.co.in:8000/STOP');
        res.send('STOP message sent to simulator');
    } catch (error) {
        res.status(500).send('Failed to send STOP message to simulator');
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
