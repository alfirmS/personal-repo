<?php
// Assuming you have already established a database connection

require './connection.php';

$name = "Sholeh Firmansyah";
$about_me = "I have experience working in teams, critical thinking, project management, and technology development. I specialize in application deployment, which involves deploying applications to servers using DevOps automation tools. Typically, I am in charge of two to three apps that contain multiple services. I want to advance my career as a DevOps engineer by experimenting use various automation tools and deploying them to make deployments faster, more efficient, and safer.";
$telp_number = "+62 813-3027-8042";
$email = "sholeh.firmansyah87@gmail.com";
$social_media1 = "sfirmansyah";
$social_media2 = "";
$social_media3 = "";
$address = "Jl. Curug Wetan";
$education1 = "Gadjah Mada University";
$education2 = "";

// Create the SQL INSERT statement
$sql = "INSERT INTO users (name, about_me, telp_number, email, social_media1, social_media2, social_media3, address, education1, education2)       
       	VALUES ('$name', '$about_me', '$telp_number', '$email', '$social_media1', '$social_media2', '$social_media3', '$address', '$education1', '$education2')";


if ($conn->query($sql) === TRUE) {
  echo "New record created successfully";
} else {
  echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

// Close the database connection
mysqli_close($conn);
?>
