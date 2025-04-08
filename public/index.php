<?php
$dsn = 'mysql:host=' . getenv('DATABASE_HOST') . ';dbname=' .getenv('DATABASE_NAME') . ';charset=utf8';
$user = getenv('DATABASE_USER');
$password = getenv('DATABASE_PASSWORD');

try {
    $pdo = new PDO($dsn, $user, $password);
    echo "Connexion réussie à MariaDB !";
} catch (PDOException $e) {
    die("Échec de la connexion : " . $e->getMessage());
}
