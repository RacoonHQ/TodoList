<?php
require_once '../config.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->email) || !isset($data->password) || !isset($data->name)) {
    sendResponse(false, 'Name, email, and password are required');
}

$name = trim($data->name);
$email = trim($data->email);
$password = $data->password;

if (strlen($password) < 6) {
    sendResponse(false, 'Password must be at least 6 characters long');
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendResponse(false, 'Invalid email format');
}

try {
    $stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->execute([$email]);
    
    if ($stmt->fetch()) {
        sendResponse(false, 'Email already exists');
    }

    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    
    $stmt = $conn->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
    $stmt->execute([$name, $email, $hashedPassword]);
    
    $userId = $conn->lastInsertId();
    $token = generateToken($userId);
    
    $stmt = $conn->prepare("INSERT INTO auth_tokens (user_id, token, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 DAY))");
    $stmt->execute([$userId, $token]);
    
    sendResponse(true, 'Registration successful', [
        'token' => $token,
        'user_id' => $userId,
        'name' => $name,
        'photo' => null
    ]);
    
} catch(PDOException $e) {
    sendResponse(false, 'Registration failed: ' . $e->getMessage());
}
?>
