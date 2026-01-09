<?php
require_once '../config.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->id)) {
    sendResponse(false, 'Note ID is required');
    exit;
}

$id = $data->id;

try {
    $stmt = $conn->prepare("DELETE FROM notes WHERE id = ?");
    if ($stmt->execute([$id])) {
        sendResponse(true, 'Note deleted successfully');
    } else {
        sendResponse(false, 'Failed to delete note');
    }
} catch(PDOException $e) {
    sendResponse(false, 'Database error: ' . $e->getMessage());
}
?>
