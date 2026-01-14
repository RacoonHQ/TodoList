import 'package:flutter/material.dart';
import '../api_service.dart';
import 'package:intl/intl.dart';

class TodosPage extends StatefulWidget {
  final List<Map<String, dynamic>> todos;
  final Function refreshTodos;

  const TodosPage({super.key, required this.todos, required this.refreshTodos});

  @override
  _TodosPageState createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.refreshTodos();
    });
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _translatePriority(String priority) {
    switch (priority) {
      case 'high':
        return 'Tinggi';
      case 'medium':
        return 'Sedang';
      case 'low':
        return 'Rendah';
      default:
        return priority;
    }
  }

  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    String selectedPriority = 'medium';
    final DateTime now = DateTime.now();
    DateTime selectedDate = DateTime(now.year, now.month, now.day);
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(selectedDate),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Tambah Tugas Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Apa yang ingin dikerjakan?',
                    prefixIcon: const Icon(Icons.edit_note, color: Colors.cyan),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Pelaksanaan',
                    prefixIcon:
                        const Icon(Icons.calendar_today, color: Colors.cyan),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedDate = picked;
                        dateController.text =
                            DateFormat('yyyy-MM-dd').format(picked);
                      });
                    }
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  initialValue: selectedPriority,
                  decoration: InputDecoration(
                    labelText: 'Prioritas Penting',
                    prefixIcon:
                        const Icon(Icons.priority_high, color: Colors.cyan),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Rendah')),
                    DropdownMenuItem(value: 'medium', child: Text('Sedang')),
                    DropdownMenuItem(value: 'high', child: Text('Tinggi')),
                  ],
                  onChanged: (value) {
                    if (value != null) selectedPriority = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final response = await ApiService.createTodo(
                    titleController.text,
                    dateController.text,
                    selectedPriority,
                  );

                  if (response['success']) {
                    Navigator.pop(context);
                    widget.refreshTodos();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Tugas berhasil ditambahkan!'),
                          backgroundColor: Colors.green),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final today = DateTime(now.year, now.month, now.day);

    final List<Map<String, dynamic>> overdueTodos = [];
    final List<Map<String, dynamic>> todayTodos = [];
    final List<Map<String, dynamic>> upcomingTodos = [];
    final List<Map<String, dynamic>> completedTodos = [];

    for (var todo in widget.todos) {
      final dateStr = todo['date'].toString();
      final status = todo['status'].toString();

      if (status == 'completed') {
        completedTodos.add(todo);
        continue;
      }

      try {
        final todoDate = DateTime.parse(dateStr);
        if (dateStr == todayStr) {
          todayTodos.add(todo);
        } else if (todoDate.isBefore(today)) {
          overdueTodos.add(todo);
        } else {
          upcomingTodos.add(todo);
        }
      } catch (e) {
        upcomingTodos.add(todo);
      }
    }

    // Sort priority within groups
    void sortByPriority(List<Map<String, dynamic>> list) {
      const priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
      list.sort((a, b) => (priorityOrder[a['priority']] ?? 1)
          .compareTo(priorityOrder[b['priority']] ?? 1));
    }

    sortByPriority(todayTodos);
    sortByPriority(upcomingTodos);
    sortByPriority(overdueTodos);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: widget.todos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_turned_in_outlined,
                      size: 80, color: Colors.cyan.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text('Ups! Belum ada tugas nih.',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const Text('Mulai dengan menekan tombol plus (+)',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async => widget.refreshTodos(),
              child: CustomScrollView(
                slivers: [
                  if (todayTodos.isNotEmpty) ...[
                    _buildSectionHeader('Tugas Hari Ini', Colors.cyan),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildTodoCard(todayTodos[index]),
                        childCount: todayTodos.length,
                      ),
                    ),
                  ],
                  if (upcomingTodos.isNotEmpty) ...[
                    _buildSectionHeader('Tugas Mendatang', Colors.blueGrey),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildTodoCard(upcomingTodos[index]),
                        childCount: upcomingTodos.length,
                      ),
                    ),
                  ],
                  if (completedTodos.isNotEmpty) ...[
                    _buildSectionHeader('Telah Selesai', Colors.green),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildTodoCard(
                            completedTodos[index],
                            isCompleted: true),
                        childCount: completedTodos.length,
                      ),
                    ),
                  ],
                  if (overdueTodos.isNotEmpty) ...[
                    _buildSectionHeader('Tugas Terlewat', Colors.redAccent),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildTodoCard(overdueTodos[index],
                            isOverdue: true),
                        childCount: overdueTodos.length,
                      ),
                    ),
                  ],
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_task),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Row(
          children: [
            Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text(title,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoCard(Map<String, dynamic> todo,
      {bool isCompleted = false, bool isOverdue = false}) {
    final bool dimmed = isCompleted || isOverdue;

    return Opacity(
      opacity: dimmed ? 0.6 : 1.0,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: dimmed ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isOverdue
              ? BorderSide(color: Colors.red.withOpacity(0.3))
              : BorderSide.none,
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 4,
            height: 30,
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.grey
                  : _getPriorityColor(todo['priority']),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          title: Text(
            todo['title'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isOverdue ? Colors.red[900] : null,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(todo['date'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(width: 12),
                Icon(Icons.flag,
                    size: 12, color: _getPriorityColor(todo['priority'])),
                const SizedBox(width: 4),
                Text(_translatePriority(todo['priority']),
                    style: TextStyle(
                        fontSize: 12,
                        color: _getPriorityColor(todo['priority']))),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: isCompleted,
                shape: const CircleBorder(),
                activeColor: Colors.cyan,
                onChanged: (value) async {
                  if (value == null) return;
                  final response = await ApiService.updateTodo(
                    int.parse(todo['id'].toString()),
                    todo['title'],
                    todo['date'],
                    value ? 'completed' : 'pending',
                  );
                  if (response['success']) widget.refreshTodos();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 20),
                onPressed: () => _confirmDelete(todo),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tugas?'),
        content: const Text('Tugas ini akan dihapus secara permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              final response =
                  await ApiService.deleteTodo(int.parse(todo['id'].toString()));
              if (response['success']) {
                Navigator.pop(context);
                widget.refreshTodos();
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
