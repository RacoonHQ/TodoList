<?php
require_once '../config.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->user_id) || !isset($data->title) || !isset($data->content)) {
    sendResponse(false, 'Missing required fields');
    exit;
}

try {
    $stmt = $conn->prepare("INSERT INTO notes (user_id, title, content) VALUES (:user_id, :title, :content)");
    $stmt->bindParam(':user_id', $data->user_id);
    $stmt->bindParam(':title', $data->title);
    $stmt->bindParam(':content', $data->content);
    
    if ($stmt->execute()) {
        sendResponse(true, 'Note created successfully');
    } else {
        sendResponse(false, 'Failed to create note');
    }
} catch(PDOException $e) {
    sendResponse(false, 'Database error: ' . $e->getMessage());
}
?>
