<?php
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, 'Method not allowed');
}

$data = json_decode(file_get_contents('php://input'), true);
$userId = $data['user_id'] ?? null;
$name = $data['name'] ?? null;
$password = $data['password'] ?? null;

if (!$userId) {
    sendResponse(false, 'User ID is required');
}

try {
    $updates = [];
    $params = [];

    if ($name) {
        $updates[] = "name = ?";
        $params[] = $name;
    }

    if ($password) {
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        $updates[] = "password = ?";
        $params[] = $hashedPassword;
    }

    if (empty($updates)) {
        sendResponse(false, 'No fields to update');
    }

    $params[] = $userId;
    $sql = "UPDATE users SET " . implode(", ", $updates) . " WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute($params);

    if ($stmt->rowCount() > 0) {
        sendResponse(true, 'Profil berhasil diperbarui');
    } else {
        sendResponse(false, 'Gagal memperbarui profil atau tidak ada perubahan');
    }
} catch (PDOException $e) {
    sendResponse(false, 'Database error: ' . $e->getMessage());
}
?>
