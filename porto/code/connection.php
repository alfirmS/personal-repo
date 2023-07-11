<?php

$servername = "localhost";  // Replace with your server name
$username = "root";  // Replace with your MySQL username
$password = "@SFirman889";  // Replace with your MySQL password
$database = "portofolio_db";  // Replace with your MySQL database name

// Create a connection
$conn = new mysqli($servername, $username, $password, $database);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
