<?php

$servername = "mysql";  // Replace with your server name
$username = "porto_user";  // Replace with your MySQL username
$password = "portoPassword";  // Replace with your MySQL password
$database = "portofolio_db";  // Replace with your MySQL database name

// Create a connection
$conn = new mysqli($servername, $username, $password, $database);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
