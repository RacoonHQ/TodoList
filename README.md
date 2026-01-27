# Todo Calendar App

A complete Flutter ToDoList application with calendar integration, user authentication, and PHP MySQL backend.

## 📋 Overview

Todo Calendar App is a comprehensive task management application built with Flutter for the frontend and PHP/MySQL for the backend. It features user authentication, calendar integration, todo management, and notes functionality with a beautiful Material Design interface.

**Developer**: Sayyid Abdullah Azzam

## ✨ Features

- **🔐 User Authentication**: Secure login and registration with JWT token-based authentication
- **📅 Calendar View**: Interactive calendar to view and manage todos by date
- **📱 5 Bottom Navigation Tabs**:
  - Calendar: Daily todo view with date selection
  - Todos: Complete todo list with CRUD operations
  - Notes: Personal notes management with text and images
  - Profile: User profile with photo upload and editing
  - Settings: App settings and logout
- **📝 Todo Management**: Create, read, update, and delete todos
- **🎯 Priority Levels**: Low, medium, and high priority todos
- **✅ Status Tracking**: Pending and completed todo status
- **🎨 Responsive Design**: Material Design with beautiful UI components
- **💾 Data Persistence**: SharedPreferences for auth tokens, MySQL for data storage
- **🌐 Cross-Platform**: Works on Android, iOS, Web, and Desktop

## 🛠 Tech Stack

### Frontend (Flutter)
- **Flutter 3.19+**: Cross-platform UI framework
- **Dart 3.4+**: Programming language
- **http: ^1.2.1**: HTTP client for API communication
- **shared_preferences: ^2.3.0**: Local storage for tokens
- **table_calendar: ^3.1.2**: Interactive calendar widget
- **intl: ^0.19.0**: Internationalization and date formatting
- **cached_network_image: ^3.3.1**: Network image caching

### Backend (PHP)
- **PHP 8.2+**: Server-side scripting language
- **MySQL 8.0+**: Relational database management system
- **RESTful API**: Architectural style for API design
- **JWT Authentication**: Secure token-based authentication
- **PDO**: PHP Data Objects for database operations
- **CORS**: Cross-Origin Resource Sharing support

## 📁 Project Structure

- **Autentikasi Pengguna**: Login dan pendaftaran menggunakan autentikasi berbasis token JWT yang aman.
- **Tampilan Kalender**: Kalender interaktif untuk melihat dan mengelola tugas berdasarkan tanggal, dilengkapi dengan pemilih bulan/tahun dan mode rentang.
- **Tab Navigasi Bawah**:
  - **Kalender**: Fokus pada tugas harian dengan antarmuka kalender yang cantik.
  - **Tugas (Todos)**: Daftar tugas lengkap dengan pengelompokan prioritas (Terlewat, Hari Ini, Mendatang, Selesai).
  - **Catatan (Notes)**: Manajemen catatan pribadi dengan teks kaya dan kemampuan **Upload Gambar**.
  - **Profil**: Kelola detail profil, ubah kata sandi, dan unggah foto profil.
- **Tingkat Prioritas**: Prioritas Rendah, Sedang, dan Tinggi dengan indikator visual status.
- **Manajemen Gambar**: Dukungan penuh untuk foto profil dan lampiran gambar pada catatan.
- **Perbaikan Cross-Platform**: Dioptimalkan untuk Web, Windows, dan Mobile (menggunakan `MemoryImage` dan `Uint8List`).
- **Dukungan CORS**: Konfigurasi `.htaccess` yang sudah terpasang untuk pemuatan gambar yang lancar di lingkungan web.

## 🛠 Teknologi yang Digunakan

### Frontend (Flutter)
- Flutter 3.19+ | Dart 3.4+
- `http`: Komunikasi API.
- `shared_preferences`: Penyimpanan status lokal.
- `table_calendar`: Logika kalender interaktif.
- `cached_network_image`: Pemuatan dan caching gambar yang dioptimalkan.
- `image_picker`: Integrasi kamera dan galeri.

### Backend (PHP)
- PHP 8.2+ | MySQL 8.0+
- API RESTful dengan dukungan JSON/Multipart.
- PDO untuk operasi database yang aman.
- Konstruksi URL dinamis untuk aset gambar.

## 📁 Struktur Proyek
>>>>>>> ae4e2276da00c89ffc0fda8325d431079e555033

```
todo_calendar_app/
├── lib/
<<<<<<< HEAD
│   ├── main.dart                    # App entry point and AuthWrapper
│   ├── auth_screen.dart             # Login and registration screens
│   ├── home_screen.dart             # Main app with 5 tabs
│   ├── api_service.dart             # HTTP client and API calls
│   ├── pages/                       # Individual page components
│   │   ├── calendar_page.dart       # Calendar view page
│   │   ├── todos_page.dart          # Todo management page
│   │   ├── notes_page.dart          # Notes management page
│   │   └── profile_page.dart        # User profile page
│   └── widgets/                     # Reusable UI components
├── api/                             # PHP Backend API
│   ├── config.php                   # Database configuration and utilities
│   ├── auth/                        # Authentication endpoints
│   │   ├── login.php                # User login endpoint
│   │   ├── register.php             # User registration endpoint
│   │   ├── update_profile.php       # Profile update endpoint
│   │   └── upload_photo.php         # Profile photo upload
│   ├── todos/                       # Todo management endpoints
│   │   ├── index.php                # Get todos for user
│   │   ├── create.php               # Create new todo
│   │   ├── update.php               # Update existing todo
│   │   └── delete.php               # Delete todo
│   ├── notes/                       # Notes management endpoints
│   │   ├── index.php                # Get notes for user
│   │   ├── create.php               # Create new note
│   │   └── delete.php               # Delete note
│   └── image-pp/                    # Profile picture storage directory
├── database/                        # Database files
│   └── database.sql                 # Complete database schema and sample data
├── assets/                          # Asset files
│   └── images/                      # Local image assets
├── API.md                           # Complete API documentation
└── pubspec.yaml                      # Flutter dependencies
```

## 🗄 Database Schema

The application uses a MySQL database named `Your database name` with the following tables:

### Users Table
```sql
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
```

**Fields:**
- `id`: Primary key (auto-increment, int(11))
- `email`: Unique email address for user login (varchar(100))
- `password`: Hashed password using PHP's `password_hash()` (varchar(255))
- `name`: User display name (varchar(100))
- `photo`: Profile picture URL (optional, varchar(255))
- `created_at`: Account creation timestamp
- `updated_at`: Last update timestamp

### Auth Tokens Table
```sql
CREATE TABLE `auth_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_token` (`token`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `auth_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
```

**Fields:**
- `id`: Primary key (auto-increment, int(11))
- `user_id`: Foreign key to users table (int(11))
- `token`: JWT authentication token (varchar(255))
- `expires_at`: Token expiration timestamp (30 days)
- `created_at`: Token creation timestamp

### Todolists Table
```sql
CREATE TABLE `todolists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `date` date NOT NULL,
  `priority` enum('low','medium','high') DEFAULT 'medium',
  `status` enum('pending','completed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_date` (`date`),
  KEY `idx_status` (`status`),
  CONSTRAINT `todolists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
```

**Fields:**
- `id`: Primary key (auto-increment, int(11))
- `user_id`: Foreign key to users table (int(11))
- `title`: Todo task title (varchar(200))
- `date`: Due date (YYYY-MM-DD format, date)
- `priority`: Task priority (enum: 'low', 'medium', 'high')
- `status`: Task status (enum: 'pending', 'completed')
- `created_at`: Task creation timestamp
- `updated_at`: Last update timestamp

### Notes Table
```sql
CREATE TABLE `notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `notes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
```

**Fields:**
- `id`: Primary key (auto-increment, int(11))
- `user_id`: Foreign key to users table (int(11))
- `title`: Note title (varchar(200))
- `content`: Note content (rich text, text)
- `image_url`: Optional image attachment URL (varchar(255))
- `created_at`: Note creation timestamp
- `updated_at`: Last update timestamp

### Database Configuration
- **Database Name**: `Your database name`
- **Character Set**: `latin1` with `latin1_swedish_ci` collation
- **Storage Engine**: InnoDB
- **Foreign Keys**: Enabled with CASCADE delete for data integrity

## 🚀 Setup Instructions
=======
│   ├── main.dart              # Titik masuk aplikasi (Entry point)
│   ├── auth/                  # Layar autentikasi
│   ├── pages/                 # Halaman tab (tugas, catatan, kalender, profil)
│   ├── home_screen.dart       # Pengontrol tab utama
│   └── api_service.dart       # Logika API terpusat
├── api/
│   ├── config.php             # Logika inti & konfigurasi DB
│   ├── auth/                  # Endpoint Pengguna & Profil
│   ├── todos/                 # Endpoint manajemen tugas
│   ├── notes/                 # Endpoint catatan & upload gambar
│   ├── image-pp/              # Penyimpanan foto profil & .htaccess
│   └── image-note/            # Penyimpanan gambar catatan & .htaccess
├── database/
│   └── database.sql           # Skema SQL
└── LICENSE                    # Lisensi MIT
```

## 🚀 Instruksi Instalasi

### 1. Pengaturan Backend
1. Unggah folder `api/` ke server Anda.
2. Impor `database/database.sql` ke instance MySQL Anda.
3. Perbarui kredensial database di `api/config.php`.
4. **Catatan**: Pastikan server memiliki izin tulis (write permissions) untuk folder `image-pp/` dan `image-note/`.

### 2. Pengaturan Frontend
1. Jalankan perintah `flutter pub get`.
2. Buka `lib/api_service.dart` dan perbarui `_baseUrl` dengan alamat server Anda.
3. Jalankan menggunakan `flutter run -d chrome --web-renderer html` (untuk web) atau cukup `flutter run`.

## 📡 Ringkasan Endpoint API
>>>>>>> ae4e2276da00c89ffc0fda8325d431079e555033

### Autentikasi
- `POST /auth/login.php` - Login pengguna.
- `POST /auth/register.php` - Daftar pengguna baru.
- `POST /auth/upload_photo.php` - Unggah foto profil (*Multipart*).

<<<<<<< HEAD
1. **Upload API Files**:
   - Upload the entire `api/` folder to your web server
   - Example: `https://your-domain.com/api/`
   - Ensure PHP 8.2+ is installed on your server

2. **Database Setup**:
   - Create a MySQL database
   - Import `database/database.sql` into your MySQL database:
     ```bash
     mysql -u username -p database_name < database/database.sql
     ```
   - Or use phpMyAdmin to import the SQL file

3. **Configure Database Connection**:
   - Edit `api/config.php` and update the database credentials:
     ```php
     $host = 'localhost';                    // Your database host
     $dbname = 'Your database name';         // Your database name
     $username = 'Your database username';   // Your database username
     $password = 'Your database password';   // Your database password
     ```

4. **Test API Endpoints**:
   - Visit `https://your-domain.com/api/auth/login.php` to ensure API is accessible
   - Check for any PHP errors or database connection issues

### 2. Frontend Setup (Flutter)

1. **Prerequisites**:
   - Install Flutter SDK (3.19+)
   - Install Dart SDK (3.4+)
   - Set up your preferred IDE (VS Code, Android Studio)

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Update API Base URL**:
   - In your API service file, update the base URL:
     ```dart
     static String _baseUrl = 'https://your-domain.com/api';
     ```

4. **Run the App**:
   ```bash
   flutter run
   ```
   - Choose your target device (Android emulator, iOS simulator, or physical device)

## 📡 API Documentation

For complete API documentation including all endpoints, request/response formats, and examples, please refer to: **[API.md](./API.md)**

### Quick API Overview

#### Authentication Endpoints
- `POST /auth/login.php` - User login
- `POST /auth/register.php` - User registration  
- `POST /auth/update_profile.php` - Update profile
- `POST /auth/upload_photo.php` - Upload profile photo

#### Todo Endpoints
- `GET /todos/index.php?user_id={id}` - Get user todos
- `POST /todos/create.php` - Create new todo
- `POST /todos/update.php` - Update existing todo
- `GET/POST /todos/delete.php` - Delete todo

#### Notes Endpoints
- `GET /notes/index.php?user_id={id}` - Get user notes
- `POST /notes/create.php` - Create new note
- `GET/POST /notes/delete.php` - Delete note

### Request Formats Supported
- **JSON**: `application/json`
- **Form Data**: `application/x-www-form-urlencoded`
- **File Upload**: `multipart/form-data` (for profile photos)

## 👥 Default Users

The database comes with sample users for testing:

| Email | Password | Name | Photo |
|-------|----------|------|-------|
| john@example.com | password | John Doe | - |
| jane@example.com | password | Jane Smith | - |
| admin@example.com | password | Admin User | - |
| sayyid@gmail.com | [hashed] | NYUHUUUU | ✅ |
| joni@joni.com | joni123 | Joni Kasep | ✅ |
| ibnu@gmail.com | [hashed] | Afri Yudha | - |
| bang@b.com | [hashed] | babang | - |
| t@t.com | [hashed] | test | - |
| a@a.com | [hashed] | apip | - |

**Note**: 
- Passwords marked as [hashed] are securely hashed in the database
- Users with ✅ have profile photos uploaded
- Change these default passwords in production environment!

**Real Test Users** (with known passwords):
- **Email**: `joni@joni.com`, **Password**: `joni123`, **Name**: `Joni Kasep`

## 🔒 Security Features

- **Password Hashing**: All passwords securely hashed using PHP's `password_hash()`
- **JWT Authentication**: Secure token-based authentication with 30-day expiration
- **SQL Injection Prevention**: PDO prepared statements for all database operations
- **CORS Configuration**: Proper Cross-Origin Resource Sharing setup
- **Input Validation**: Server-side validation for all user inputs
- **File Upload Security**: Image validation and size limits for profile photos

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Error**:
   - Verify database credentials in `api/config.php`
   - Ensure MySQL server is running and accessible
   - Check database name and user permissions

2. **CORS Errors**:
   - Ensure API server has proper CORS headers configured
   - Verify base URL in Flutter app matches API domain
   - Check that API is accessible from your Flutter app

3. **Authentication Issues**:
   - Clear app data and try logging in again
   - Verify JWT tokens are being stored properly
   - Check token expiration time (30 days by default)

4. **Calendar Display Issues**:
   - Ensure `table_calendar` package is properly installed
   - Verify date formatting matches API expectations (YYYY-MM-DD)

5. **Image Upload Issues**:
   - Check `image-pp/` directory permissions on server
   - Verify file size limits (max 1MB)
   - Ensure proper MIME type validation

## 🧪 Testing

### API Testing with Postman
1. Import the Postman collection from [API.md](./API.md)
2. Set up environment variables:
   - `base_url`: Your API domain
   - `user_id`: Test user ID
   - `token`: Authentication token
3. Test all endpoints following the documentation

### Flutter Testing
```bash
# Run unit tests
flutter test

# Run widget tests
flutter test integration_test/

# Build for testing
flutter build apk --debug
```

## 📱 Build & Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is open source and available under the MIT License. See the [LICENSE](LICENSE) file for details.

## 📞 Support

For issues, questions, or contributions:
- Create an issue in the project repository
- Check the [API.md](./API.md) for API-related questions
- Review the troubleshooting section above

---

**Developed by Sayyid Abdullah Azzam**
=======
### Tugas (Todos)
- `GET /todos/index.php?user_id=ID` - Ambil daftar tugas.
- `POST /todos/create.php` - Tambah tugas baru.
- `PUT /todos/update.php` - Ubah status atau edit tugas.

### Catatan (Notes)
- `GET /notes/index.php?user_id=ID` - Ambil daftar catatan.
- `POST /notes/upload_image.php` - Unggah gambar untuk catatan (*Multipart*).
- `POST /notes/create.php` - Simpan catatan dengan opsional `image_url`.

## 🔐 Keamanan & Optimasi
- **Perbaikan CORS**: File `.htaccess` yang disertakan mengizinkan akses browser standar ke gambar statis.
- **Pencegahan Race Condition**: Pemuatan data diurutkan setelah sinkronisasi pengguna berhasil.
- **User-Agent Mocking**: Frontend menyertakan header khusus untuk melewati blokir beberapa host gambar.

## 📄 Lisensi
Proyek ini dilisensikan di bawah **Lisensi MIT**. Lihat file `LICENSE` untuk detail lebih lanjut.

---
>>>>>>> ae4e2276da00c89ffc0fda8325d431079e555033
