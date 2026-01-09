-- Todo Calendar App Database Schema
-- MySQL 8.0+

-- Create database
CREATE DATABASE IF NOT EXISTS bere9277_db_sayyid CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bere9277_db_sayyid;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Authentication tokens table
CREATE TABLE IF NOT EXISTS auth_tokens (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_user_id (user_id)
);

-- Todo lists table
CREATE TABLE IF NOT EXISTS todolists (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    date DATE NOT NULL,
    priority ENUM('low','medium','high') DEFAULT 'medium',
    status ENUM('pending','completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_date (date),
    INDEX idx_status (status)
);

-- Articles table
CREATE TABLE IF NOT EXISTS notes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_created_at (created_at)
);

-- Insert sample data
-- Sample users
INSERT INTO users (email, password, name) VALUES
('john@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John Doe'),
('jane@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jane Smith'),
('admin@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin User');

-- Sample todos for John Doe (user_id = 1)
INSERT INTO todolists (user_id, title, date, priority, status) VALUES
(1, 'Complete Flutter project', '2024-01-15', 'high', 'pending'),
(1, 'Review PHP API code', '2024-01-15', 'medium', 'completed'),
(1, 'Setup MySQL database', '2024-01-16', 'high', 'completed'),
(1, 'Write documentation', '2024-01-17', 'low', 'pending'),
(1, 'Test authentication flow', '2024-01-18', 'medium', 'pending'),
(1, 'Deploy to production', '2024-01-20', 'high', 'pending');

-- Sample todos for Jane Smith (user_id = 2)
INSERT INTO todolists (user_id, title, date, priority, status) VALUES
(2, 'Design UI mockups', '2024-01-15', 'high', 'completed'),
(2, 'Create wireframes', '2024-01-16', 'medium', 'completed'),
(2, 'User testing session', '2024-01-17', 'high', 'pending'),
(2, 'Update color scheme', '2024-01-18', 'low', 'pending');


-- Note: The password hash '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' corresponds to 'password'
-- You can change these passwords in your production environment
