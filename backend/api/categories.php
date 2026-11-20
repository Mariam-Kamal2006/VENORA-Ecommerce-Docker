<?php
require_once __DIR__ . '/../config/db.php';

$stmt = $pdo->query(
    "SELECT category_id, category_name, description, image_url
     FROM categories
     ORDER BY category_id"
);

respond($stmt->fetchAll());