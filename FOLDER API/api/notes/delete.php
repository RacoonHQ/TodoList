<?php
require_once '../config.php';

// Check request method and get data accordingly
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // GET request - use query parameters
    $id = $_GET['id'] ?? null;
} else {
    // POST request - check if data is sent as JSON or form data
    $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
    
    if (strpos($contentType, 'application/json') !== false) {
        // JSON input
        $data = json_decode(file_get_contents("php://input"));
        $id = $data->id ?? null;
    } else {
        // Form data input (x-www-form-urlencoded)
        $id = $_POST['id'] ?? null;
    }
}

if (!$id) {
    sendResponse(false, 'Note ID is required');
    exit;
}

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
