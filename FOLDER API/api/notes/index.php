<?php
require_once '../config.php';

if (!isset($_GET['user_id'])) {
    sendResponse(false, 'User ID is required');
}

$user_id = $_GET['user_id'];

try {
    $stmt = $conn->prepare("SELECT id, title, content, image_url, created_at FROM notes WHERE user_id = ? ORDER BY created_at DESC");
    $stmt->execute([$user_id]);
    $notes = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    sendResponse(true, 'Notes retrieved successfully', ['notes' => $notes]);
    
} catch(PDOException $e) {
    sendResponse(false, 'Failed to retrieve notes: ' . $e->getMessage());
}
?>
