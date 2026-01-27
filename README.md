# TodoList App

Aplikasi Manajemen Tugas (Todo List) lengkap dengan integrasi kalender, autentikasi pengguna, dan sinkronisasi data menggunakan backend PHP MySQL.

## Bahasa Pemrograman & Teknologi

| Komponen | Teknologi |
|----------|-----------|
| **Frontend** | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) |
| **Backend** | ![PHP](https://img.shields.io/badge/PHP-777BB4?style=flat&logo=php&logoColor=white) ![REST_API](https://img.shields.io/badge/REST_API-005571?style=flat) |
| **Database** | ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white) |
| **Integrasi** | ![Token_Auth](https://img.shields.io/badge/Token_Auth-FF6F00?style=flat) ![JSON](https://img.shields.io/badge/JSON-000000?style=flat&logo=json&logoColor=white) |

---

## Overview

**TodoList App** adalah solusi manajemen tugas komprehensif yang dirancang untuk membantu pengguna mengatur jadwal harian mereka dengan lebih efisien. Menggunakan **Flutter** untuk antarmuka yang modern dan responsif, serta **PHP/MySQL** untuk penyimpanan data yang aman dan terpusat.

**Pengembang**: Sayyid Abdullah Azzam

## Fitur Utama

- **Autentikasi Pengguna**: Sistem Login dan Daftar yang aman menggunakan token.
- **Integrasi Kalender**: Tampilan kalender interaktif untuk memantau tugas berdasarkan tanggal.
- **Navigasi 5 Tab Utama**:
  - **Kalender**: Lihat tugas harian melalui antarmuka kalender.
  - **Tugas (Todos)**: Manajemen tugas lengkap (CRUD).
  - **Catatan (Notes)**: Simpan catatan pribadi beserta lampiran gambar.
  - **Profil**: Personalisasi akun dengan foto profil.
  - **Pengaturan**: Konfigurasi aplikasi dan opsi keluar (logout).
- **Skala Prioritas**: Kategorikan tugas Anda menjadi Rendah, Sedang, atau Tinggi.
- **Status Tugas**: Pantau kemajuan tugas (Pending atau Selesai).
- **Desain Material 3**: Antarmuka pengguna yang bersih, modern, dan intuitif.
- **Lintas Platform**: Mendukung penggunaan di Android, iOS, Web, dan Desktop.

---

## Struktur Proyek

```text
todo_list_project/
├── lib/                     # Sumber kode Flutter (Frontend)
│   ├── main.dart            # Titik awal aplikasi & Wrapper Autentikasi
│   ├── api_service.dart     # Logika komunikasi REST API terpusat
│   ├── pages/               # Halaman-halaman aplikasi (Calendar, Todos, Notes, Profile)
│   └── widgets/             # Komponen UI yang dapat digunakan kembali
├── api/                     # Sumber kode PHP (Backend)
│   ├── config.php           # Logika inti & Konfigurasi Database
│   ├── auth/                # Endpoint Autentikasi & Manajemen Profil
│   ├── todos/               # Endpoint Manajemen Tugas (CRUD)
│   ├── notes/               # Endpoint Manajemen Catatan & Gambar
│   ├── image-pp/            # Tempat penyimpanan foto profil
│   └── image-note/          # Tempat penyimpanan gambar catatan
├── database/                # Skema Database
│   └── database.sql         # Skema database lengkap & data sampel
└── assets/                  # Aset gambar dan ikon aplikasi
```

---

## Skema Database

Aplikasi menggunakan database MySQL dengan tabel-tabel berikut:

### 1. Tabel `users`
Menyimpan informasi dasar pengguna dan referensi foto profil.
- `id`: Primary Key.
- `email`: Alamat email unik penggunas.
- `password`: Password yang di-hash.
- `name`: Nama tampilan.
- `photo`: Nama file/path foto profil.

### 2. Tabel `auth_tokens`
Menyimpan token sesi aktif untuk validasi akses API.
- `user_id`: Relasi ke tabel users.
- `token`: Token unik akses.
- `expires_at`: Masa berlaku token (30 hari).

### 3. Tabel `todolists`
Menyimpan daftar tugas setiap pengguna.
- `user_id`: Relasi ke pemilik tugas.
- `title`: Judul tugas.
- `date`: Tanggal jatuh tempo.
- `priority`: Rendah, Sedang, Tinggi.
- `status`: Pending, Completed.

### 4. Tabel `notes`
Menyimpan catatan pribadi.
- `user_id`: Relasi ke pemilik catatan.
- `title`: Judul catatan.
- `content`: Isi catatan.
- `image_url`: URL/Path gambar lampiran (opsional).

---

## Panduan Instalasi

### 1. Pengaturan Backend (PHP & MySQL)
1. Unggah seluruh isi folder `api/` ke server web Anda.
2. Buat database MySQL dan impor file `database/database.sql`.
3. Buka `api/config.php` dan sesuaikan kredensial database:
   ```php
   $host = 'localhost';
   $dbname = 'nama_database_anda';
   $username = 'username_database';
   $password = 'password_database';
   ```
4. Pastikan folder `image-pp/` dan `image-note/` memiliki izin tulis (*write permissions*) pada server.

### 2. Pengaturan Frontend (Flutter)
1. Pastikan Flutter SDK (v3.19+) sudah terinstal.
2. Jalankan perintah berikut di terminal:
   ```bash
   flutter pub get
   ```
3. Buka `lib/api_service.dart` dan perbarui variabel `_baseUrl` dengan alamat API Anda:
   ```dart
   static String _baseUrl = 'https://domain-anda.com/api';
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

---

## Dokumentasi API

Untuk rincian lengkap mengenai endpoint, format Request/Response, dan contoh penggunaan menggunakan Postman, silakan merujuk pada: **[API.md](./API.md)**

### Ringkasan Endpoint Utama:

| Fitur | Method | Endpoint |
|-------|--------|----------|
| **Login** | POST | `/auth/login.php` |
| **Daftar** | POST | `/auth/register.php` |
| **Ambil Tugas** | GET | `/todos/index.php?user_id=ID` |
| **Tambah Tugas**| POST | `/todos/create.php` |
| **Update Tugas**| PUT | `/todos/update.php` |
| **Hapus Tugas** | DELETE | `/todos/delete.php?id=ID` |
| **Ambil Catatan**| GET | `/notes/index.php?user_id=ID` |
| **Tambah Catatan**| POST | `/notes/create.php` |

---

## Keamanan & Optimasi

- **Hashing**: Semua password disimpan dalam bentuk hash aman menggunakan `password_hash()`.
- **Prepared Statements**: Menggunakan PDO untuk mencegah serangan SQL Injection.
- **Token Sessions**: Setiap akses API memerlukan validasi token yang disimpan di tabel `auth_tokens`.
- **CORS**: Pengaturan header di `config.php` mendukung akses antar platform yang aman.
- **Validation**: Data divalidasi dengan ketat baik di sisi frontend maupun backend.

---

## Kontribusi & Lisensi

Kami sangat menghargai kontribusi Anda! Silakan *Fork* repositori ini, buat *branch* fitur baru, dan ajukan *Pull Request*.

Proyek ini dilisensikan di bawah **Lisensi MIT**. Lihat file `LICENSE` untuk detail lebih lanjut.

---
**Dikembangkan oleh Sayyid Abdullah Azzam**
