# Todo Calendar App

Aplikasi ToDoList lengkap dengan integrasi kalender, autentikasi pengguna, dan backend PHP MySQL.

## 🚀 Fitur Utama

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

```
todo_calendar_app/
├── lib/
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

### Autentikasi
- `POST /auth/login.php` - Login pengguna.
- `POST /auth/register.php` - Daftar pengguna baru.
- `POST /auth/upload_photo.php` - Unggah foto profil (*Multipart*).

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