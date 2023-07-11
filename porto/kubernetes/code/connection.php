<?php

$servername = "10.96.215.155";  // Replace with your server name
$username = "root";  // Replace with your MySQL username
$password = "passwordPorto";  // Replace with your MySQL password
$database = "portofoliodb";  // Replace with your MySQL database name

// Create a connection
$conn = new mysqli($servername, $username, $password, $database);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
