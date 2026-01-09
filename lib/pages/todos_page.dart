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
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.refreshTodos();
    });
  }

  @override
  void didUpdateWidget(TodosPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild when todos list changes
    setState(() {});
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

  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final priorityController = TextEditingController(text: 'medium');
    final dateController = TextEditingController(
      text: DateTime.now().toString().substring(0, 10),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              initialValue: 'medium',
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: ['low', 'medium', 'high'].map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                priorityController.text = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  dateController.text.isNotEmpty) {
                final response = await ApiService.createTodo(
                  titleController.text,
                  dateController.text,
                  priorityController.text,
                );

                if (response['success']) {
                  Navigator.pop(context);
                  widget.refreshTodos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todo added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response['message']),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Todos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: widget.todos.isEmpty
          ? const Center(
              child: Text(
                'No todos yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Builder(
              builder: (context) {
                final todayStr =
                    DateFormat('yyyy-MM-dd').format(DateTime.now());
                final todayTodos = widget.todos
                    .where((todo) => todo['date'] == todayStr)
                    .toList();

                final highTodos = widget.todos
                    .where((todo) => todo['priority'] == 'high')
                    .toList();
                final mediumTodos = widget.todos
                    .where((todo) => todo['priority'] == 'medium')
                    .toList();
                final lowTodos = widget.todos
                    .where((todo) => todo['priority'] == 'low')
                    .toList();

                return CustomScrollView(
                  slivers: [
                    // Today Section
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          'Hari Ini',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    if (todayTodos.isEmpty)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Tidak ada yang harus dilakukan hari ini',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildTodoCard(todayTodos[index]),
                          childCount: todayTodos.length,
                        ),
                      ),

                    // Divider
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(thickness: 1),
                      ),
                    ),

                    if (highTodos.isNotEmpty) ...[
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Text(
                            'High Priority',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildTodoCard(highTodos[index]),
                          childCount: highTodos.length,
                        ),
                      ),
                    ],
                    if (mediumTodos.isNotEmpty) ...[
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            'Medium Priority',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _buildTodoCard(mediumTodos[index]),
                          childCount: mediumTodos.length,
                        ),
                      ),
                    ],
                    if (lowTodos.isNotEmpty) ...[
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            'Low Priority',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildTodoCard(lowTodos[index]),
                          childCount: lowTodos.length,
                        ),
                      ),
                    ],
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 80), // Bottom padding
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoCard(Map<String, dynamic> todo) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(todo['title']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${todo['date']}'),
            Text('Priority: ${todo['priority']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: todo['status'] == 'completed',
              onChanged: (value) async {
                final response = await ApiService.updateTodo(
                  int.parse(todo['id'].toString()),
                  todo['title'],
                  todo['date'],
                  value! ? 'completed' : 'pending',
                );

                if (response['success']) {
                  widget.refreshTodos();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final response = await ApiService.deleteTodo(
                    int.parse(todo['id'].toString()));
                if (response['success']) {
                  widget.refreshTodos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todo deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        leading: Container(
          width: 4,
          height: double.infinity,
          color: _getPriorityColor(todo['priority']),
        ),
      ),
    );
  }
}
