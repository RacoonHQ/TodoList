# Todo Calendar App

A complete Flutter ToDoList application with calendar integration, user authentication, and PHP MySQL backend.

## Features

- **User Authentication**: Login and registration with JWT token-based authentication
- **Calendar View**: Interactive calendar to view and manage todos by date
- **5 Bottom Navigation Tabs**:
  - Calendar: Daily todo view with date selection
  - Todos: Complete todo list with CRUD operations
  - Notes: Personal notes management with text and images
  - Profile: User profile with photo upload and editing
  - Settings: App settings and logout
- **Todo Management**: Create, read, update, and delete todos
- **Priority Levels**: Low, medium, and high priority todos
- **Status Tracking**: Pending and completed todo status
- **Responsive Design**: Material Design with beautiful UI components
- **Data Persistence**: SharedPreferences for auth tokens, MySQL for data storage

## Tech Stack

### Frontend (Flutter)
- Flutter 3.19+
- Dart 3.4+
- http: ^1.2.1 (API communication)
- shared_preferences: ^2.3.0 (Local storage)
- table_calendar: ^3.1.2 (Calendar widget)
- intl: ^0.19.0 (Date formatting)
- cached_network_image: ^3.3.1 (Image caching)

### Backend (PHP)
- PHP 8.2+
- MySQL 8.0+
- RESTful API architecture
- JWT authentication
- PDO for database operations

## Project Structure

```
todo_calendar_app/
├── lib/
│   ├── main.dart              # App entry point and AuthWrapper
│   ├── auth_screen.dart       # Login and registration screens
│   ├── home_screen.dart       # Main app with 5 tabs
│   └── api_service.dart       # HTTP client and API calls
├── api/
│   ├── config.php             # Database configuration and utilities
│   ├── auth/
│   │   ├── login.php          # User login endpoint
│   │   └── register.php       # User registration endpoint
│   ├── todos/
│   │   ├── index.php          # Get todos for user
│   │   ├── create.php         # Create new todo
│   │   ├── update.php         # Update existing todo
│   │   └── delete.php         # Delete todo
│   ├── notes/
│   │   ├── index.php          # Get notes for user
│   │   ├── create.php         # Create new note
│   │   └── delete.php         # Delete note
│   └── image-pp/              # Profile picture storage 
├── database/
│   └── database.sql           # Database schema and sample data
├── assets/
│   └── images/                # Local image assets
└── pubspec.yaml              # Flutter dependencies
```

## Database Schema

### Users Table
- `id`: Primary key
- `email`: Unique email address
- `password`: Hashed password
- `name`: User display name
- `photo`: Profile picture URL (added)
- `created_at`: Account creation timestamp

### Todolists Table
- `id`: Primary key
- `user_id`: Foreign key to users table
- `title`: Todo title
- `date`: Due date (YYYY-MM-DD format)
- `priority`: low, medium, or high
- `status`: pending or completed
- `created_at`: Creation timestamp

### Notes Table
- `id`: Primary key
- `user_id`: Foreign key to users table
- `title`: Note title
- `content`: Note content
- `image_url`: Optional image URL
- `created_at`: Creation timestamp
## Setup Instructions

### 1. Backend Setup (PHP + MySQL)

1. **Upload API Files**:
   - Upload the entire `api/` folder to your web server (e.g., `domain.com/api/`)
   - Ensure PHP 8.2+ is installed on your server

2. **Database Setup**:
   - Create a MySQL database named `todo_calendar_db`
   - Import `database/database.sql` into your MySQL database using phpMyAdmin or command line:
     ```sql
     mysql -u username -p todo_calendar_db < database.sql
     ```

3. **Configure Database Connection**:
   - Edit `api/config.php` and update the database credentials:
     ```php
     $host = 'localhost';        // Your database host
     $dbname = 'todo_calendar_db'; // Your database name
     $username = 'root';         // Your database username
     $password = '';             // Your database password
     ```

4. **Test API Endpoints**:
   - Visit `domain.com/api/auth/login.php` to ensure the API is accessible

### 2. Frontend Setup (Flutter)

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Update API Base URL**:
   - In `lib/api_service.dart`, update the base URL:
     ```dart
     static String _baseUrl = 'https://your-domain.com/api';
     ```

3. **Run the App**:
   ```bash
   flutter run
   ```

## API Endpoints

### Authentication
- `POST /api/auth/login.php` - User login
  - Request: `{ "email": "user@example.com", "password": "password" }`
  - Response: `{ "success": true, "message": "Login successful", "data": { "token": "...", "user_id": 1, "name": "...", "photo": "..." } }`

- `POST /api/auth/register.php` - User registration
  - Request: `{ "email": "user@example.com", "password": "password", "name": "John Doe" }`
  - Response: `{ "success": true, "message": "Registration successful", "data": { "token": "...", "user_id": 1, "name": "...", "photo": null } }`

- `POST /api/auth/update_profile.php` - Update profile info
  - Request: `{ "user_id": 1, "name": "New Name", "password": "new_password" }`
  - Response: `{ "success": true, "message": "Profil berhasil diperbarui" }`

- `POST /api/auth/upload_photo.php` - Upload profile picture
  - Request: `multipart/form-data` with fields `user_id` and `photo` (file)
  - Response: `{ "success": true, "message": "...", "data": { "photo_url": "..." } }`

### Todos
- `GET /api/todos/index.php?user_id=1` - Get user todos
  - Response: `{ "success": true, "message": "...", "data": { "todos": [...] } }`

- `POST /api/todos/create.php` - Create new todo
  - Request: `{ "user_id": 1, "title": "New Task", "date": "2024-01-15", "priority": "high" }`
  - Response: `{ "success": true, "message": "...", "data": { "todo": {...} } }`

- `PUT /api/todos/update.php` - Update todo
  - Request: `{ "id": 1, "title": "Updated Task", "date": "2024-01-15", "status": "completed" }`
  - Response: `{ "success": true, "message": "Todo updated successfully" }`

- `DELETE /api/todos/delete.php?id=1` - Delete todo
  - Response: `{ "success": true, "message": "Todo deleted successfully" }`

### Notes
- `GET /api/notes/index.php?user_id=1` - Get user notes
  - Response: `{ "success": true, "message": "...", "data": { "notes": [...] } }`

- `POST /api/notes/create.php` - Create new note
  - Request: `{ "user_id": 1, "title": "Note Title", "content": "Note content..." }`
  - Response: `{ "success": true, "message": "Note created successfully" }`

- `POST /api/notes/delete.php` - Delete note
  - Request: `{ "id": 1 }`
  - Response: `{ "success": true, "message": "Note deleted successfully" }`
## Default Users

The database comes with sample users for testing:

| Email | Password | Name |
|-------|----------|------|
| john@example.com | password | John Doe |
| jane@example.com | password | Jane Smith |
| admin@example.com | password | Admin User |

## Security Features

- **Password Hashing**: All passwords are securely hashed using PHP's `password_hash()`
- **JWT Authentication**: Secure token-based authentication with expiration
- **SQL Injection Prevention**: PDO prepared statements for all database operations
- **CORS Configuration**: Proper Cross-Origin Resource Sharing setup
- **Input Validation**: Server-side validation for all user inputs

## Troubleshooting

### Common Issues

1. **Database Connection Error**:
   - Check your database credentials in `api/config.php`
   - Ensure MySQL server is running
   - Verify database name and user permissions

2. **CORS Errors**:
   - Ensure your API server has proper CORS headers
   - Check that the base URL in `api_service.dart` is correct

3. **Authentication Issues**:
   - Clear app data and try logging in again
   - Check that JWT tokens are being stored properly
   - Verify token expiration time (30 days by default)

4. **Calendar Display Issues**:
   - Ensure `table_calendar` package is properly installed
   - Check that date formatting matches API expectations (YYYY-MM-DD)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the MIT License.

## Support

For issues and questions, please create an issue in the project repository.

---

**Happy Coding! 🚀**
