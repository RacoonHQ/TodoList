<?php
require_once '../config.php';

if (!isset($_GET['user_id'])) {
    sendResponse(false, 'User ID is required');
}

$userId = intval($_GET['user_id']);

try {
    $stmt = $conn->prepare("SELECT id, title, date, priority, status, created_at FROM todolists WHERE user_id = ? ORDER BY date, created_at");
    $stmt->execute([$userId]);
    $todos = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    sendResponse(true, 'Todos retrieved successfully', ['todos' => $todos]);
    
} catch(PDOException $e) {
    sendResponse(false, 'Failed to retrieve todos: ' . $e->getMessage());
}
?>
