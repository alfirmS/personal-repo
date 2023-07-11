<?php

$host = "localhost"; // alamat server database
$username = "root"; // nama pengguna database
$password = "password"; // kata sandi database

// membuat koneksi ke server database
$conn = mysqli_connect($host, $username, $password);

// memeriksa koneksi
if (!$conn) {
    die("Koneksi gagal: " . mysqli_connect_error());
}

// membuat database baru
$database = "portofolio_db";
$sql = "CREATE DATABASE $database";

if (mysqli_query($conn, $sql)) {
    echo "Database berhasil dibuat";
} else {
    echo "Error saat membuat database: " . mysqli_error($conn);
}

// menutup koneksi
mysqli_close($conn);
