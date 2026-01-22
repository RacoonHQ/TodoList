import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _showAddNoteDialog() {
    _titleController.clear();
    _contentController.clear();

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
                        maxLines: 5,
                        validator: (value) =>
                            value!.isEmpty ? 'Silakan masukkan konten' : null,
                      ),
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
                            final result = await ApiService.createNote(
                              _titleController.text,
                              _contentController.text,
                            );
                            setState(() => _isSaving = false);

                            if (result['success']) {
                              if (!mounted) return;
                              Navigator.pop(context);
                              widget.refreshNotes();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Catatan berhasil ditambahkan!'),
                                    backgroundColor: Colors.green),
                              );
                            }
                          }
                        },
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
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
                              imageUrl: article['image_url'],
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
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
                                child: const Icon(Icons.broken_image_outlined,
                                    size: 50, color: Colors.grey),
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
