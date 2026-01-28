<?php
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, 'Method not allowed');
}

$userId = $_POST['user_id'] ?? null;

if (!$userId) {
    sendResponse(false, 'User ID is required');
}

if (!isset($_FILES['photo'])) {
    sendResponse(false, 'No photo uploaded');
}

$file = $_FILES['photo'];
$targetDir = "../image-pp/";
$fileExtension = pathinfo($file['name'], PATHINFO_EXTENSION);
$fileName = "profile_" . $userId . "_" . time() . "." . $fileExtension;
$targetFile = $targetDir . $fileName;

// Check file size (redundant because Flutter already checks, but good for safety)
if ($file['size'] > 1 * 1024 * 1024) {
    sendResponse(false, 'Ukuran foto maksimal 1MB');
}

// Check if image file is an actual image
$check = getimagesize($file['tmp_name']);
if ($check === false) {
    sendResponse(false, 'File is not an image');
}

if (move_uploaded_file($file['tmp_name'], $targetFile)) {
    try {
        // Try to add photo column if it doesn't exist (safety)
        try {
            $conn->exec("ALTER TABLE users ADD COLUMN IF NOT EXISTS photo VARCHAR(255)");
        } catch (PDOException $e) {
            // Already exists or DB doesn't support IF NOT EXISTS in ALTER
        }

        // Get current protocol and host
        $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
        $host = $_SERVER['HTTP_HOST'];
        $scriptPath = str_replace('/auth/upload_photo.php', '', $_SERVER['SCRIPT_NAME']);
        $photoUrl = $protocol . "://" . $host . $scriptPath . "/image-pp/" . $fileName;

        $stmt = $conn->prepare("UPDATE users SET photo = ? WHERE id = ?");
        $stmt->execute([$photoUrl, $userId]);

        sendResponse(true, 'Foto profil berhasil diunggah', ['photo_url' => $photoUrl]);
    } catch (PDOException $e) {
        sendResponse(false, 'Database error: ' . $e->getMessage());
    }
} else {
    sendResponse(false, 'Failed to save photo');
}
?>
