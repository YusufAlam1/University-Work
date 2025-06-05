<?php
try {
    $db = new PDO('mysql:host=localhost;dbname=alamy1_db', 'alamy1_local', 'H>FOaf2)');
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}
?>

<!-- alamy1_local -->
<!-- H>FOaf2) -->