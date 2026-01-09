import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../api_service.dart';
import 'package:flutter/cupertino.dart';

class CalendarPage extends StatefulWidget {
  final List<Map<String, dynamic>> todos;
  final Function refreshTodos;

  const CalendarPage(
      {super.key, required this.todos, required this.refreshTodos});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isRangeMode = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  void didUpdateWidget(CalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {}); // Rebuild when todos list changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo Calendar'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _showMonthYearPicker,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          DateFormat('MMMM yyyy').format(_focusedDay),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: () {
                        setState(() {
                          _isRangeMode = !_isRangeMode;
                          if (!_isRangeMode) {
                            _startDate = null;
                            _endDate = null;
                          }
                        });
                      },
                      color: _isRangeMode ? Colors.blue : Colors.grey,
                    ),
                    if (_isRangeMode)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Range Mode',
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              if (_isRangeMode) {
                return isSameDay(_startDate, day) || isSameDay(_endDate, day);
              }
              return isSameDay(_selectedDay, day);
            },
            rangeStartDay: _startDate,
            rangeEndDay: _endDate,
            rangeSelectionMode: _isRangeMode
                ? RangeSelectionMode.enforced
                : RangeSelectionMode.disabled,
            onDaySelected: (selectedDay, focusedDay) {
              if (!_isRangeMode) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _startDate = start;
                _endDate = end;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(fontSize: 0),
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
          ),
          Expanded(
            child: _buildTodosForSelectedDay(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodosForSelectedDay() {
    List<Map<String, dynamic>> filteredTodos = [];

    if (_isRangeMode) {
      if (_startDate != null && _endDate != null) {
        // Filter by date range
        filteredTodos = widget.todos.where((todo) {
          try {
            final todoDate = DateTime.parse(todo['date']);
            return (todoDate.isAtSameMomentAs(_startDate!) ||
                    todoDate.isAfter(_startDate!)) &&
                (todoDate.isAtSameMomentAs(_endDate!) ||
                    todoDate.isBefore(_endDate!));
          } catch (e) {
            return false; // Skip invalid dates
          }
        }).toList();
      } else {
        filteredTodos = [];
      }
    } else {
      // Filter by single selected date
      final selectedDate = _selectedDay != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDay!)
          : DateFormat('yyyy-MM-dd').format(_focusedDay);

      filteredTodos =
          widget.todos.where((todo) => todo['date'] == selectedDate).toList();
    }

    if (filteredTodos.isEmpty) {
      return Center(
        child: Text(
          _isRangeMode
              ? 'No todos in selected date range'
              : 'No todos for this date',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            _isRangeMode
                ? '${filteredTodos.length} todos from ${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd').format(_endDate!)}'
                : '${filteredTodos.length} todos for ${DateFormat('MMM dd, yyyy').format(_selectedDay ?? _focusedDay)}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredTodos.length,
            itemBuilder: (context, index) {
              final todo = filteredTodos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(todo['title']),
                  subtitle: Text('Priority: ${todo['priority']}'),
                  trailing: Checkbox(
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
                  leading: Container(
                    width: 4,
                    height: double.infinity,
                    color: _getPriorityColor(todo['priority']),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showMonthYearPicker() {
    int selectedMonth = _focusedDay.month;
    int selectedYear = _focusedDay.year;
    const int startYear = 2020;
    const int endYear = 2030;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          title: const Center(
              child: Text(
                  'Select Month & Year')), // Optional title to match style better or remove
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: Row(
              children: [
                // Month Picker
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedMonth - 1,
                    ),
                    selectionOverlay: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.blue, width: 1.5),
                          bottom: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                    ),
                    onSelectedItemChanged: (index) {
                      selectedMonth = index + 1;
                    },
                    children: List.generate(12, (index) {
                      return Center(
                        child: Text(
                          DateFormat('MMM').format(DateTime(2022, index + 1)),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 20),
                // Year Picker
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedYear - startYear,
                    ),
                    selectionOverlay: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.blue, width: 1.5),
                          bottom: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                    ),
                    onSelectedItemChanged: (index) {
                      selectedYear = startYear + index;
                    },
                    children: List.generate(endYear - startYear + 1, (index) {
                      return Center(
                        child: Text(
                          '${startYear + index}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final currentDay = _focusedDay.day;
                  final safeDay = currentDay > 28
                      ? 1
                      : currentDay; // Use day 1 for months with fewer days
                  _focusedDay = DateTime(selectedYear, selectedMonth, safeDay);
                  if (_selectedDay != null) {
                    final selectedDay = _selectedDay!.day;
                    final selectedSafeDay = selectedDay > 28 ? 1 : selectedDay;
                    _selectedDay =
                        DateTime(selectedYear, selectedMonth, selectedSafeDay);
                  }
                });
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
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

  void _showAddTodoDialog() {
    final titleController = TextEditingController();
    final priorityController = TextEditingController(text: 'medium');

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
              if (titleController.text.isNotEmpty) {
                final date = _selectedDay != null
                    ? DateFormat('yyyy-MM-dd').format(_selectedDay!)
                    : DateFormat('yyyy-MM-dd').format(_focusedDay);

                final response = await ApiService.createTodo(
                  titleController.text,
                  date,
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
}
