import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../api_service.dart';

class NotesPage extends StatefulWidget {
  final List<Map<String, dynamic>> articles;
  final VoidCallback refreshNotes;

  const NotesPage({
    super.key,
    required this.articles,
    required this.refreshNotes,
  });

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage([StateSetter? dialogState]) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final int sizeInBytes = await image.length();
      final double sizeInMb = sizeInBytes / (1024 * 1024);

      if (sizeInMb > 1) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ukuran gambar maksimal 1MB'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final bytes = await image.readAsBytes();

      if (dialogState != null) {
        dialogState(() {
          _pickedImage = image;
          _pickedImageBytes = bytes;
        });
      }

      setState(() {
        _pickedImage = image;
        _pickedImageBytes = bytes;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddNoteDialog() {
    _titleController.clear();
    _contentController.clear();
    _pickedImage = null;
    _pickedImageBytes = null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: const Text('Tambah Catatan Baru'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Judul Catatan',
                          prefixIcon:
                              const Icon(Icons.title, color: Colors.cyan),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Silakan masukkan judul' : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          labelText: 'Isi Catatan',
                          prefixIcon:
                              const Icon(Icons.notes, color: Colors.cyan),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        maxLines: 3,
                        validator: (value) =>
                            value!.isEmpty ? 'Silakan masukkan konten' : null,
                      ),
                      const SizedBox(height: 15),
                      if (_pickedImageBytes != null) ...[
                        Container(
                          height: 150,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: MemoryImage(_pickedImageBytes!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(setState),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.change_circle, size: 20),
                          label: const Text('Ganti Gambar'),
                        ),
                      ] else
                        InkWell(
                          onTap: () => _pickImage(setState),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.5,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade100,
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.image,
                                    size: 50, color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                Text('Ketuk untuk menambahkan gambar',
                                    style:
                                        TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isSaving
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isSaving = true);
                            try {
                              String? imageUrl;

                              // Upload image if exists
                              if (_pickedImage != null) {
                                final imageResponse =
                                    await ApiService.uploadNoteImage(
                                        _pickedImage!);
                                if (!imageResponse['success']) {
                                  if (!mounted) return;
                                  setState(() => _isSaving = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Gagal mengunggah gambar: ${imageResponse['message']}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                imageUrl = imageResponse['image_url'];
                              }

                              // Create note with or without image
                              final result = await ApiService.createNote(
                                _titleController.text,
                                _contentController.text,
                                imageUrl: imageUrl,
                              );

                              if (!mounted) return;
                              setState(() => _isSaving = false);

                              if (result['success']) {
                                Navigator.pop(context);
                                widget.refreshNotes();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Catatan berhasil ditambahkan!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Gagal menambahkan catatan: ${result['message']}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() => _isSaving = false);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Terjadi kesalahan: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.articles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined,
                      size: 80, color: Colors.cyan.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text('Belum ada catatan.',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const Text('Tulis ide-ide brilianmu di sini!',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async => widget.refreshNotes(),
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: widget.articles.length,
                itemBuilder: (context, index) {
                  final article = widget.articles[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        // Action when tapping on note card
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (article['image_url'] != null &&
                              article['image_url'].isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: article['image_url'].toString().trim(),
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              httpHeaders: const {
                                'User-Agent':
                                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                              },
                              placeholder: (context, url) => Container(
                                height: 180,
                                color: Colors.grey[200],
                                child: const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.cyan)),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 180,
                                color: Colors.grey[100],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.broken_image_outlined,
                                        size: 40, color: Colors.grey),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Gagal memuat gambar',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        article['title'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.redAccent, size: 22),
                                      onPressed: () => _confirmDelete(article),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  article['content'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                      height: 1.4),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month,
                                        size: 14, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDate(article['created_at']),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        child: const Icon(Icons.post_add),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  void _confirmDelete(Map<String, dynamic> article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Hapus Catatan?'),
        content: const Text('Catatan ini akan dihapus secara permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              final int noteId = int.tryParse(article['id'].toString()) ?? 0;
              final result = await ApiService.deleteNote(noteId);
              if (result['success']) {
                Navigator.pop(context);
                widget.refreshNotes();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Catatan berhasil dihapus'),
                      backgroundColor: Colors.green),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
