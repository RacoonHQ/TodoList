# Dokumentasi API - TodoList

Dokumentasi ringkas untuk integrasi backend PHP MySQL dengan frontend Flutter.

## Struktur Folder API
Seluruh kode backend tersedia di folder [FOLDER API/api/](./FOLDER%20API/api/).

```text
api/
├── auth/           # Login, Register, Profile, Photo basic
├── todos/          # CRUD Tugas (Index, Create, Update, Delete)
├── notes/          # CRUD Catatan & Upload Gambar
├── image-pp/       # Penyimpanan Foto Profil
├── image-note/     # Penyimpanan Gambar Catatan
└── config.php      # Koneksi Database & Fungsi Inti
```

---

## Skema Database
Detail skema database lengkap dapat ditemukan di folder [FOLDER DATABASE/database/](./FOLDER%20DATABASE/database/).

| Tabel | Deskripsi |
|-------|-----------|
| **users** | Menyimpan data user (id, name, email, password, photo) |
| **auth_tokens**| Token sesi aktif (user_id, token, expires_at) |
| **todolists** | Daftar tugas (user_id, title, date, priority, status) |
| **notes** | Catatan pribadi (user_id, title, content, image_url) |

---

## Autentikasi
Gunakan header berikut untuk endpoint yang memerlukan proteksi:
`Authorization: Bearer <token_anda>`

---

## API Endpoints

### 1. Autentikasi (`/auth`)
| Endpoint | Method | Parameter Utama | Deskripsi |
|----------|--------|-----------------|-----------|
| `register.php` | POST | name, email, password | Daftar akun baru |
| `login.php` | POST | email, password | Masuk & dapatkan token |
| `update_profile.php`| POST | user_id, name, password | Update nama/sandi |
| `upload_photo.php` | POST | user_id, photo (file) | Ganti foto profil |

### 2. Tugas/Todos (`/todos`)
| Endpoint | Method | Parameter Utama | Deskripsi |
|----------|--------|-----------------|-----------|
| `index.php` | GET | user_id | Ambil semua tugas |
| `create.php` | POST | user_id, title, date, priority | Tambah tugas baru |
| `update.php` | POST | id, title, date, status | Update data tugas |
| `delete.php` | POST/GET| id | Hapus tugas |

### 3. Catatan/Notes (`/notes`)
| Endpoint | Method | Parameter Utama | Deskripsi |
|----------|--------|-----------------|-----------|
| `index.php` | GET | user_id | Ambil semua catatan |
| `create.php` | POST | user_id, title, content, image_url| Simpan catatan |
| `upload_image.php` | POST | image (file) | Upload gambar catatan |
| `delete.php` | POST/GET| id | Hapus catatan |

---

## Format Response (JSON)
```json
{
    "success": true,
    "message": "Pesan status",
    "data": { ... }
}
```

---
**Base URL:** `https://sayyid.bersama.cloud/api`
