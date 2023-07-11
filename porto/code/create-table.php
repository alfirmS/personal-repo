<?php

// Include the file containing the database connection code
require 'connection.php';

// SQL query to create a table
$sql = "CREATE TABLE IF NOT EXISTS users (
id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
about_me VARCHAR(500) NOT NULL,
telp_number VARCHAR(50) NOT NULL,
email VARCHAR(100) NOT NULL,
social_media1 VARCHAR(100) NOT NULL,
social_media2 VARCHAR(100) NOT NULL,
social_media3 VARCHAR(100) NOT NULL,
address VARCHAR(100) NOT NULL,
education1 VARCHAR(100) NOT NULL,
education2 VARCHAR(100) NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

// Execute the query
if ($conn->query($sql) === true) {
    echo "Table created successfully <br>";
} else {
    echo "Error creating table: " . $conn->error;
    echo "<br>";
}

// Close the connection
$conn->close();
