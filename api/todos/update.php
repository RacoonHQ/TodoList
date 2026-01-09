<?php
require_once '../config.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->id) || !isset($data->title) || !isset($data->date) || !isset($data->status)) {
    sendResponse(false, 'ID, title, date, and status are required');
}

$id = intval($data->id);
$title = trim($data->title);
$date = $data->date;
$status = $data->status;

if (!in_array($status, ['pending', 'completed'])) {
    sendResponse(false, 'Status must be pending or completed');
}

if (!DateTime::createFromFormat('Y-m-d', $date)) {
    sendResponse(false, 'Invalid date format. Use YYYY-MM-DD');
}

try {
    $stmt = $conn->prepare("UPDATE todolists SET title = ?, date = ?, status = ? WHERE id = ?");
    $result = $stmt->execute([$title, $date, $status, $id]);
    
    if ($stmt->rowCount() > 0) {
        sendResponse(true, 'Todo updated successfully');
    } else {
        sendResponse(false, 'Todo not found or no changes made');
    }
    
} catch(PDOException $e) {
    sendResponse(false, 'Failed to update todo: ' . $e->getMessage());
}
?>
