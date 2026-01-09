<?php
require_once '../config.php';

if (!isset($_GET['id'])) {
    sendResponse(false, 'Todo ID is required');
}

$id = intval($_GET['id']);

try {
    $stmt = $conn->prepare("DELETE FROM todolists WHERE id = ?");
    $result = $stmt->execute([$id]);
    
    if ($stmt->rowCount() > 0) {
        sendResponse(true, 'Todo deleted successfully');
    } else {
        sendResponse(false, 'Todo not found');
    }
    
} catch(PDOException $e) {
    sendResponse(false, 'Failed to delete todo: ' . $e->getMessage());
}
?>
