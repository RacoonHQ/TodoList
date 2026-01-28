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

if (!isset($data->email) || !isset($data->password)) {
    sendResponse(false, 'Email and password are required');
}

$email = trim($data->email);
$password = $data->password;

try {
    $stmt = $conn->prepare("SELECT id, name, password, photo FROM users WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($password, $user['password'])) {
        $token = generateToken($user['id']);
        
        $stmt = $conn->prepare("INSERT INTO auth_tokens (user_id, token, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 DAY))");
        $stmt->execute([$user['id'], $token]);
        
        sendResponse(true, 'Login successful', [
            'token' => $token,
            'user_id' => $user['id'],
            'name' => $user['name'],
            'photo' => $user['photo']
        ]);
    } else {
        sendResponse(false, 'Invalid email or password');
    }
} catch(PDOException $e) {
    sendResponse(false, 'Login failed: ' . $e->getMessage());
}
?>
