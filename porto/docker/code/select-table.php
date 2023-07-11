<?php

require './connection.php';

$sql_data = "SELECT * FROM users WHERE name = 'Sholeh Firmansyah'";

// Execute the query
$result_data = mysqli_query($conn, $sql_data);

$row_data = mysqli_fetch_assoc($result_data);

$name = $row_data["name"];
$aboutMe = $row_data["about_me"];
$telpNum = $row_data["telp_number"];
$email = $row_data["email"];
$socMed1 = $row_data["social_media1"];
$socMed2 = $row_data["social_media2"];
$socMed3 = $row_data["social_media3"];
$address = $row_data["address"];
$education1 = $row_data["education1"];
$education2 = $row_data["education2"];
