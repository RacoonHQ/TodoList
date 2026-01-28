<?php
require_once '../config.php';

// Check if data is sent as JSON or form data
$contentType = $_SERVER['CONTENT_TYPE'] ?? '';

if (strpos($contentType, 'application/json') !== false) {
    // JSON input
    $data = json_decode(file_get_contents("php://input"));
} else {
    // Form data input (x-www-form-urlencoded)
    $data = (object) $_POST;
}

if (!isset($data->user_id) || !isset($data->title) || !isset($data->content)) {
    sendResponse(false, 'Missing required fields');
    exit;
}

try {
    // Ensure image_url column exists
    try {
        $conn->exec("ALTER TABLE notes ADD COLUMN IF NOT EXISTS image_url VARCHAR(255) DEFAULT NULL");
    } catch (PDOException $e) {
        // Column might already exist or DB doesn't support IF NOT EXISTS
    }

    $imageUrl = isset($data->image_url) ? $data->image_url : null;

    $stmt = $conn->prepare("INSERT INTO notes (user_id, title, content, image_url) VALUES (:user_id, :title, :content, :image_url)");
    $stmt->bindParam(':user_id', $data->user_id);
    $stmt->bindParam(':title', $data->title);
    $stmt->bindParam(':content', $data->content);
    $stmt->bindParam(':image_url', $imageUrl);
    
    if ($stmt->execute()) {
        sendResponse(true, 'Note created successfully');
    } else {
        sendResponse(false, 'Failed to create note');
    }
} catch(PDOException $e) {
    sendResponse(false, 'Database error: ' . $e->getMessage());
}
?>
