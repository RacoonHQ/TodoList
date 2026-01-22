# TodoList API - Complete Documentation

## 📋 Overview

TodoList API adalah RESTful API yang dibangun dengan PHP dan MySQL untuk mengelola aplikasi TodoList. API ini menyediakan endpoint untuk autentikasi pengguna, manajemen todo, dan catatan (notes).

## 🌐 Base URL

```
https://sayyid.bersama.cloud/api
```

## 🔐 Authentication

API menggunakan token-based authentication. Setelah login atau registrasi berhasil, token akan dihasilkan dan harus disertakan dalam header `Authorization`.

### Header Format
```
Authorization: Bearer <token>
```

### Token Expiration
- Token berlaku selama 30 hari
- Token disimpan dalam tabel `auth_tokens`

---

## 📊 API Endpoints

### 🔑 Authentication Endpoints

#### 1. Register User
**POST** `/auth/register.php`

Membuat akun pengguna baru dan mengembalikan token autentikasi.

**Request Body Options:**

**Option 1: JSON (application/json)**
```json
{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
}
```

**Option 2: x-www-form-urlencoded**
```
name=John Doe&email=john@example.com&password=password123
```

**Response:**
```json
{
    "success": true,
    "message": "Registration successful",
    "data": {
        "token": "generated_token_here",
        "user_id": 123,
        "name": "John Doe",
        "photo": null
    }
}
```

**Validation Rules:**
- `name`: Required, trimmed
- `email`: Required, valid email format, unique
- `password`: Required, minimum 6 characters

---

#### 2. Login User
**POST** `/auth/login.php`

Mengautentikasi pengguna dan mengembalikan token autentikasi.

**Request Body Options:**

**Option 1: JSON (application/json)**
```json
{
    "email": "john@example.com",
    "password": "password123"
}
```

**Option 2: x-www-form-urlencoded**
```
email=john@example.com&password=password123
```

**Response:**
```json
{
    "success": true,
    "message": "Login successful",
    "data": {
        "token": "generated_token_here",
        "user_id": 123,
        "name": "John Doe",
        "photo": "https://sayyid.bersama.cloud/image-pp/profile_123_timestamp.jpg"
    }
}
```

---

#### 3. Update Profile
**POST** `/auth/update_profile.php`

Memperbarui informasi profil pengguna (nama dan/atau password).

**Request Body Options:**

**Option 1: JSON (application/json)**
```json
{
    "user_id": 123,
    "name": "John Updated",
    "password": "newpassword123"
}
```

**Option 2: x-www-form-urlencoded**
```
user_id=123&name=John Updated&password=newpassword123
```

**Response:**
```json
{
    "success": true,
    "message": "Profil berhasil diperbarui"
}
```

---

#### 4. Upload Profile Photo
**POST** `/auth/upload_photo.php`

Mengunggah dan memperbarui foto profil pengguna.

**Request Format:** `multipart/form-data`

**Form Fields:**
- `user_id`: User ID (required)
- `photo`: Image file (required)

**Response:**
```json
{
    "success": true,
    "message": "Foto profil berhasil diunggah",
    "data": {
        "photo_url": "https://sayyid.bersama.cloud/image-pp/profile_123_timestamp.jpg"
    }
}
```

---

### 📝 Todos Endpoints

#### 1. Get All Todos
**GET** `/todos/index.php`

Mengambil semua todo untuk pengguna tertentu.

**Query Parameters:**
- `user_id`: User ID (required)

**Example:** `GET /todos/index.php?user_id=123`

**Response:**
```json
{
    "success": true,
    "message": "Todos retrieved successfully",
    "data": {
        "todos": [
            {
                "id": 1,
                "title": "Complete project",
                "date": "2024-01-15",
                "priority": "high",
                "status": "pending",
                "created_at": "2024-01-10 10:00:00"
            }
        ]
    }
}
```

---

#### 2. Create Todo
**POST** `/todos/create.php`

Membuat item todo baru.

**Request Body Options:**

**Option 1: JSON (application/json)**
```json
{
    "user_id": 123,
    "title": "New task",
    "date": "2024-01-20",
    "priority": "medium"
}
```

**Option 2: x-www-form-urlencoded**
```
user_id=123&title=New task&date=2024-01-20&priority=medium
```

**Response:**
```json
{
    "success": true,
    "message": "Todo created successfully",
    "data": {
        "todo": {
            "id": 456,
            "title": "New task",
            "date": "2024-01-20",
            "priority": "medium",
            "status": "pending",
            "created_at": "2024-01-15 14:30:00"
        }
    }
}
```

**Validation Rules:**
- `priority`: Must be 'low', 'medium', or 'high'
- `date`: Format YYYY-MM-DD

---

#### 3. Update Todo
**POST** `/todos/update.php`

Memperbarui item todo yang ada.

**Request Body Options:**

**Option 1: JSON (application/json)**
```json
{
    "id": 456,
    "title": "Updated task",
    "date": "2024-01-25",
    "status": "completed"
}
```

**Option 2: x-www-form-urlencoded**
```
id=456&title=Updated task&date=2024-01-25&status=completed
```

**Response:**
```json
{
    "success": true,
    "message": "Todo updated successfully"
}
```

**Validation Rules:**
- `status`: Must be 'pending' or 'completed'
- `date`: Format YYYY-MM-DD

---

#### 4. Delete Todo
**GET** `/todos/delete.php` atau **POST** `/todos/delete.php`

Menghapus item todo.

**GET Request (Query Parameters):**
- `id`: Todo ID (required)

**Example:** `GET /todos/delete.php?id=456`

**POST Request Body Options:**

**Option 1: JSON (application/json)**
```json
{
    "id": 456
}
```

**Option 2: x-www-form-urlencoded**
```
id=456
```

**Response:**
```json
{
    "success": true,
    "message": "Todo deleted successfully"
}
```

---

### 📄 Notes Endpoints

#### 1. Get All Notes
**GET** `/notes/index.php`

Mengambil semua catatan untuk pengguna tertentu.

**Query Parameters:**
- `user_id`: User ID (required)

**Example:** `GET /notes/index.php?user_id=123`

**Response:**
```json
{
    "success": true,
    "message": "Notes retrieved successfully",
    "data": {
        "notes": [
            {
                "id": 1,
                "title": "Meeting Notes",
                "content": "Important discussion points...",
                "image_url": "https://sayyid.bersama.cloud/image-pp/note_image.jpg",
                "created_at": "2024-01-10 09:00:00"
            }
        ]
    }
}
```

---

#### 2. Create Note
**POST** `/notes/create.php`

Membuat catatan baru.

**Request Body Options:**

**Option 1: JSON (application/json)**
```json
{
    "user_id": 123,
    "title": "New Note",
    "content": "Note content here..."
}
```

**Option 2: x-www-form-urlencoded**
```
user_id=123&title=New Note&content=Note content here...
```

**Response:**
```json
{
    "success": true,
    "message": "Note created successfully"
}
```

---

#### 3. Delete Note
**GET** `/notes/delete.php` atau **POST** `/notes/delete.php`

Menghapus catatan.

**GET Request (Query Parameters):**
- `id`: Note ID (required)

**Example:** `GET /notes/delete.php?id=789`

**POST Request Body Options:**

**Option 1: JSON (application/json)**
```json
{
    "id": 789
}
```

**Option 2: x-www-form-urlencoded**
```
id=789
```

**Response:**
```json
{
    "success": true,
    "message": "Note deleted successfully"
}
```

---

## 🛠️ Postman Collection

### Environment Variables

Buat environment variables di Postman untuk kemudahan:

```json
{
    "base_url": "https://sayyid.bersama.cloud/api",
    "user_id": "123",
    "token": "your_token_here"
}
```

### Collection Structure

1. **Authentication**
   - Register
   - Login
   - Update Profile
   - Upload Photo

2. **Todos**
   - Get All Todos
   - Create Todo
   - Update Todo
   - Delete Todo

3. **Notes**
   - Get All Notes
   - Create Note
   - Delete Note

### Sample Postman Requests

#### Register User

**Option 1: JSON**
```http
POST {{base_url}}/auth/register.php
Content-Type: application/json

{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123"
}
```

**Option 2: x-www-form-urlencoded**
```http
POST {{base_url}}/auth/register.php
Content-Type: application/x-www-form-urlencoded

name=Test User&email=test@example.com&password=password123
```

#### Login User

**Option 1: JSON**
```http
POST {{base_url}}/auth/login.php
Content-Type: application/json

{
    "email": "test@example.com",
    "password": "password123"
}
```

**Option 2: x-www-form-urlencoded**
```http
POST {{base_url}}/auth/login.php
Content-Type: application/x-www-form-urlencoded

email=test@example.com&password=password123
```

#### Get Todos (with auth)
```http
GET {{base_url}}/todos/index.php?user_id={{user_id}}
Authorization: Bearer {{token}}
```

---

## 📋 Database Schema

### Users Table
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    photo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Auth Tokens Table
```sql
CREATE TABLE auth_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    expires_at DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### Todolists Table
```sql
CREATE TABLE todolists (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    priority ENUM('low', 'medium', 'high') NOT NULL,
    status ENUM('pending', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### Notes Table
```sql
CREATE TABLE notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

## 🔒 Security Features

1. **Password Hashing**: Menggunakan `password_hash()` dengan algoritma default PHP
2. **Input Validation**: Semua input divalidasi dan disanitasi
3. **SQL Injection Prevention**: Menggunakan prepared statements dengan PDO
4. **CORS Protection**: Dikonfigurasi untuk cross-origin requests
5. **File Upload Security**: Validasi image dan batasan ukuran untuk upload foto
6. **Token-based Authentication**: Generasi dan validasi token yang aman

---

## 📝 Response Format

Semua response API mengikuti format ini:

```json
{
    "success": true|false,
    "message": "Response message",
    "data": {} // Optional data payload
}
```

---

## � Request Format Support

API ini mendukung multiple request formats untuk POST dan PUT endpoints:

### Supported Content Types:
1. **application/json** - JSON format
2. **application/x-www-form-urlencoded** - URL encoded form data

### How to Use:

#### For JSON requests:
```http
Content-Type: application/json

{
    "field1": "value1",
    "field2": "value2"
}
```

#### For x-www-form-urlencoded requests:
```http
Content-Type: application/x-www-form-urlencoded

field1=value1&field2=value2
```

### Notes:
- API secara otomatis mendeteksi format request
- Response selalu dalam format JSON
- File upload (photo) menggunakan `multipart/form-data`
- GET requests menggunakan query parameters

---

## �🚨 Error Handling

HTTP Status Codes:
- `200`: Success
- `201`: Created
- `400`: Bad Request (validation errors, missing fields)
- `401`: Unauthorized (invalid credentials)
- `404`: Not Found
- `500`: Internal Server Error (database errors)

---

## 🏗️ Project Structure

```
api/
├── config.php              # Database configuration and utility functions
├── auth/
│   ├── login.php          # User login
│   ├── register.php       # User registration
│   ├── update_profile.php # Profile updates
│   └── upload_photo.php   # Profile photo upload
├── todos/
│   ├── index.php          # Get all todos
│   ├── create.php         # Create todo
│   ├── update.php         # Update todo
│   └── delete.php         # Delete todo
├── notes/
│   ├── index.php          # Get all notes
│   ├── create.php         # Create note
│   └── delete.php         # Delete note
└── image-pp/              # Profile photo storage directory
```

---

## 🧪 Testing dengan Postman

### 1. Import Collection
1. Copy JSON collection di bawah
2. Buka Postman
3. Klik Import > Raw text
4. Paste dan import

### 2. Postman Collection JSON

```json
{
    "info": {
        "name": "TodoList API",
        "description": "Complete API documentation for TodoList application",
        "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
    },
    "variable": [
        {
            "key": "base_url",
            "value": "https://sayyid.bersama.cloud/api",
            "type": "string"
        },
        {
            "key": "user_id",
            "value": "123",
            "type": "string"
        },
        {
            "key": "token",
            "value": "",
            "type": "string"
        }
    ],
    "item": [
        {
            "name": "Authentication",
            "item": [
                {
                    "name": "Register",
                    "request": {
                        "method": "POST",
                        "header": [
                            {
                                "key": "Content-Type",
                                "value": "application/json"
                            }
                        ],
                        "body": {
                            "mode": "raw",
                            "raw": "{\n    \"name\": \"Test User\",\n    \"email\": \"test@example.com\",\n    \"password\": \"password123\"\n}"
                        },
                        "url": {
                            "raw": "{{base_url}}/auth/register.php",
                            "host": ["{{base_url}}"],
                            "path": ["auth","register.php"]
                        }
                    }
                },
                {
                    "name": "Login",
                    "request": {
                        "method": "POST",
                        "header": [
                            {
                                "key": "Content-Type",
                                "value": "application/json"
                            }
                        ],
                        "body": {
                            "mode": "raw",
                            "raw": "{\n    \"email\": \"test@example.com\",\n    \"password\": \"password123\"\n}"
                        },
                        "url": {
                            "raw": "{{base_url}}/auth/login.php",
                            "host": ["{{base_url}}"],
                            "path": ["auth","login.php"]
                        }
                    },
                    "event": [
                        {
                            "listen": "test",
                            "script": {
                                "exec": [
                                    "if (pm.response.code === 200) {",
                                    "    const response = pm.response.json();",
                                    "    if (response.success && response.data.token) {",
                                    "        pm.collectionVariables.set('token', response.data.token);",
                                    "        pm.collectionVariables.set('user_id', response.data.user_id.toString());",
                                    "    }",
                                    "}"
                                ]
                            }
                        }
                    ]
                },
                {
                    "name": "Update Profile",
                    "request": {
                        "method": "POST",
                        "header": [
                            {
                                "key": "Content-Type",
                                "value": "application/json"
                            }
                        ],
                        "body": {
                            "mode": "raw",
                            "raw": "{\n    \"user_id\": {{user_id}},\n    \"name\": \"Updated Name\",\n    \"password\": \"newpassword123\"\n}"
                        },
                        "url": {
                            "raw": "{{base_url}}/auth/update_profile.php",
                            "host": ["{{base_url}}"],
                            "path": ["auth","update_profile.php"]
                        }
                    }
                }
            ]
        },
        {
            "name": "Todos",
            "item": [
                {
                    "name": "Get All Todos",
                    "request": {
                        "method": "GET",
                        "header": [
                            {
                                "key": "Authorization",
                                "value": "Bearer {{token}}"
                            }
                        ],
                        "url": {
                            "raw": "{{base_url}}/todos/index.php?user_id={{user_id}}",
                            "host": ["{{base_url}}"],
                            "path": ["todos","index.php"],
                            "query": [
                                {
                                    "key": "user_id",
                                    "value": "{{user_id}}"
                                }
                            ]
                        }
                    }
                },
                {
                    "name": "Create Todo",
                    "request": {
                        "method": "POST",
                        "header": [
                            {
                                "key": "Content-Type",
                                "value": "application/json"
                            },
                            {
                                "key": "Authorization",
                                "value": "Bearer {{token}}"
                            }
                        ],
                        "body": {
                            "mode": "raw",
                            "raw": "{\n    \"user_id\": {{user_id}},\n    \"title\": \"New Task\",\n    \"date\": \"2024-12-31\",\n    \"priority\": \"medium\"\n}"
                        },
                        "url": {
                            "raw": "{{base_url}}/todos/create.php",
                            "host": ["{{base_url}}"],
                            "path": ["todos","create.php"]
                        }
                    }
                },
                {
                    "name": "Update Todo",
                    "request": {
                        "method": "POST",
                        "header": [
                            {
                                "key": "Content-Type",
                                "value": "application/json"
                            },
                            {
                                "key": "Authorization",
                                "value": "Bearer {{token}}"
                            }
                        ],
                        "body": {
                            "mode": "raw",
                            "raw": "{\n    \"id\": 1,\n    \"title\": \"Updated Task\",\n    \"date\": \"2024-12-31\",\n    \"status\": \"completed\"\n}"
                        },
                        "url": {
                            "raw": "{{base_url}}/todos/update.php",
                            "host": ["{{base_url}}"],
                            "path": ["todos","update.php"]
                        }
                    }
                },
                {
                    "name": "Delete Todo",
                    "request": {
                        "method": "GET",
                        "header": [
                            {
                                "key": "Authorization",
                                "value": "Bearer {{token}}"
                            }
                        ],
                        "url": {
                            "raw": "{{base_url}}/todos/delete.php?id=1",
                            "host": ["{{base_url}}"],
                            "path": ["todos","delete.php"],
                            "query": [
                                {
                                    "key": "id",
                                    "value": "1"
                                }
                            ]
                        }
                    }
                }
            ]
        },
        {
            "name": "Notes",
            "item": [
                {
                    "name": "Get All Notes",
                    "request": {
                        "method": "GET",
                        "header": [
                            {
                                "key": "Authorization",
                                "value": "Bearer {{token}}"
                            }
                        ],
                        "url": {
                            "raw": "{{base_url}}/notes/index.php?user_id={{user_id}}",
                            "host": ["{{base_url}}"],
                            "path": ["notes","index.php"],
                            "query": [
                                {
                                    "key": "user_id",
                                    "value": "{{user_id}}"
                                }
                            ]
                        }
                    }
                },
                {
                    "name": "Create Note",
                    "request": {
                        "method": "POST",
                        "header": [
                            {
                                "key": "Content-Type",
                                "value": "application/json"
                            },
                            {
                                "key": "Authorization",
                                "value": "Bearer {{token}}"
                            }
                        ],
                        "body": {
                            "mode": "raw",
                            "raw": "{\n    \"user_id\": {{user_id}},\n    \"title\": \"New Note\",\n    \"content\": \"Note content here...\"\n}"
                        },
                        "url": {
                            "raw": "{{base_url}}/notes/create.php",
                            "host": ["{{base_url}}"],
                            "path": ["notes","create.php"]
                        }
                    }
                },
                {
                    "name": "Delete Note",
                    "request": {
                        "method": "POST",
                        "header": [
                            {
                                "key": "Content-Type",
                                "value": "application/json"
                            },
                            {
                                "key": "Authorization",
                                "value": "Bearer {{token}}"
                            }
                        ],
                        "body": {
                            "mode": "raw",
                            "raw": "{\n    \"id\": 1\n}"
                        },
                        "url": {
                            "raw": "{{base_url}}/notes/delete.php",
                            "host": ["{{base_url}}"],
                            "path": ["notes","delete.php"]
                        }
                    }
                }
            ]
        }
    ]
}
```

---

## 📝 Development Notes

- **PHP Version**: 7.4+
- **Database**: MySQL 5.7+
- **Database Operations**: Menggunakan PDO
- **Date Format**: YYYY-MM-DD
- **Image Storage**: `/api/image-pp/` directory
- **Token Expiration**: 30 hari
- **Request/Response Format**: JSON only

---

## 🚀 Quick Start

1. **Setup Database**: Import SQL schema di atas
2. **Configure**: Update database credentials di `config.php`
3. **Test**: Gunakan Postman collection yang disediakan
4. **Deploy**: Upload ke server dengan PHP dan MySQL

---

## 📞 Support

Untuk pertanyaan atau masalah, silakan hubungi development team.

---

*Last Updated: January 2026*
