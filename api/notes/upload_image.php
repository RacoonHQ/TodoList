<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers, Content-Type, Access-Control-Allow-Methods, Authorization, X-Requested-With');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

// Check if image file was uploaded
if (!isset($_FILES['image'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'No image file provided. FILES: ' . json_encode($_FILES)]);
    exit;
}

$image = $_FILES['image'];

// Check for upload errors
if ($image['error'] !== UPLOAD_ERR_OK) {
    http_response_code(400);
    $error_messages = [
        UPLOAD_ERR_INI_SIZE => 'File exceeds upload_max_filesize in php.ini',
        UPLOAD_ERR_FORM_SIZE => 'File exceeds MAX_FILE_SIZE in HTML form',
        UPLOAD_ERR_PARTIAL => 'File was only partially uploaded',
        UPLOAD_ERR_NO_FILE => 'No file was uploaded',
        UPLOAD_ERR_NO_TMP_DIR => 'Missing a temporary folder',
        UPLOAD_ERR_CANT_WRITE => 'Failed to write file to disk',
        UPLOAD_ERR_EXTENSION => 'A PHP extension stopped the file upload'
    ];
    $msg = isset($error_messages[$image['error']]) ? $error_messages[$image['error']] : 'Unknown upload error';
    echo json_encode(['success' => false, 'message' => 'Error uploading file: ' . $msg]);
    exit;
}

// Validate file type
$allowed_extensions = ['jpg', 'jpeg', 'png', 'gif'];
$file_extension = strtolower(pathinfo($image['name'], PATHINFO_EXTENSION));

// More robust type checking
$is_image = false;
$check = getimagesize($image['tmp_name']);
if ($check !== false) {
    $is_image = true;
} else {
    // Fallback to extension check if getimagesize fails (might happen on some systems for some formats)
    if (in_array($file_extension, $allowed_extensions)) {
        $is_image = true;
    }
}

if (!$is_image) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Only JPG, PNG & GIF files are allowed. Extension: ' . $file_extension]);
    exit;
}

// Validate file size (max 5MB)
$max_size = 5 * 1024 * 1024; // 5MB
if ($image['size'] > $max_size) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'File size exceeds 5MB limit']);
    exit;
}

// Set upload directory
$upload_dir = __DIR__ . '/../image-note/';
if (!file_exists($upload_dir)) {
    if (!mkdir($upload_dir, 0755, true)) {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Failed to create upload directory']);
        exit;
    }
}

// Generate unique filename
$file_extension = strtolower(pathinfo($image['name'], PATHINFO_EXTENSION));
$filename = uniqid('note_') . '_' . time() . '.' . $file_extension;
$target_path = $upload_dir . $filename;

// Move uploaded file to target directory
if (move_uploaded_file($image['tmp_name'], $target_path)) {
    // Dynamic URL construction
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
    $host = $_SERVER['HTTP_HOST'];
    // Remove the current script name from the path to get the base API path
    $scriptPath = str_replace('/notes/upload_image.php', '', $_SERVER['SCRIPT_NAME']);
    $image_url = $protocol . "://" . $host . $scriptPath . "/image-note/" . $filename;
    
    echo json_encode([
        'success' => true,
        'message' => 'Image uploaded successfully',
        'image_url' => $image_url
    ]);
} else {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Failed to upload image']);
}
?>