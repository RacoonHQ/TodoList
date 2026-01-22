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

if (!isset($data->user_id) || !isset($data->title) || !isset($data->date) || !isset($data->priority)) {
    sendResponse(false, 'User ID, title, date, and priority are required');
}

$userId = intval($data->user_id);
$title = trim($data->title);
$date = $data->date;
$priority = $data->priority;

if (!in_array($priority, ['low', 'medium', 'high'])) {
    sendResponse(false, 'Priority must be low, medium, or high');
}

if (!DateTime::createFromFormat('Y-m-d', $date)) {
    sendResponse(false, 'Invalid date format. Use YYYY-MM-DD');
}

try {
    $stmt = $conn->prepare("INSERT INTO todolists (user_id, title, date, priority) VALUES (?, ?, ?, ?)");
    $stmt->execute([$userId, $title, $date, $priority]);
    
    $todoId = $conn->lastInsertId();
    
    $stmt = $conn->prepare("SELECT id, title, date, priority, status, created_at FROM todolists WHERE id = ?");
    $stmt->execute([$todoId]);
    $todo = $stmt->fetch(PDO::FETCH_ASSOC);
    
    sendResponse(true, 'Todo created successfully', ['todo' => $todo]);
    
} catch(PDOException $e) {
    sendResponse(false, 'Failed to create todo: ' . $e->getMessage());
}
?>
