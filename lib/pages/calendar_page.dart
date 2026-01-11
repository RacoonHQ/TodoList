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

  String _translatePriority(String priority) {
    switch (priority) {
      case 'high':
        return 'Tinggu';
      case 'medium':
        return 'Sedang';
      case 'low':
        return 'Rendah';
      default:
        return priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _showMonthYearPicker,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(_focusedDay),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.cyan),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(_isRangeMode ? Icons.date_range : Icons.today),
                  tooltip: _isRangeMode
                      ? 'Matikan Mode Rentang'
                      : 'Aktifkan Mode Rentang',
                  onPressed: () {
                    setState(() {
                      _isRangeMode = !_isRangeMode;
                      if (!_isRangeMode) {
                        _startDate = null;
                        _endDate = null;
                      }
                    });
                  },
                  color: _isRangeMode ? Colors.cyan : Colors.grey,
                ),
              ],
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
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
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.3), shape: BoxShape.circle),
              selectedDecoration: const BoxDecoration(
                  color: Colors.cyan, shape: BoxShape.circle),
              rangeStartDecoration: const BoxDecoration(
                  color: Colors.cyan, shape: BoxShape.circle),
              rangeEndDecoration: const BoxDecoration(
                  color: Colors.cyan, shape: BoxShape.circle),
              rangeHighlightColor: Colors.cyan.withOpacity(0.1),
              markerDecoration: const BoxDecoration(
                  color: Colors.cyanAccent, shape: BoxShape.circle),
            ),
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
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodosForSelectedDay() {
    List<Map<String, dynamic>> filteredTodos = [];
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (_isRangeMode) {
      if (_startDate != null && _endDate != null) {
        filteredTodos = widget.todos.where((todo) {
          try {
            final todoDate = DateTime.parse(todo['date']);
            return (todoDate.isAtSameMomentAs(_startDate!) ||
                    todoDate.isAfter(_startDate!)) &&
                (todoDate.isAtSameMomentAs(_endDate!) ||
                    todoDate.isBefore(_endDate!));
          } catch (e) {
            return false;
          }
        }).toList();
      }
    } else {
      final selectedDate = _selectedDay != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDay!)
          : DateFormat('yyyy-MM-dd').format(_focusedDay);

      filteredTodos =
          widget.todos.where((todo) => todo['date'] == selectedDate).toList();
    }

    if (filteredTodos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_outlined,
                size: 60, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 12),
            Text(
              _isRangeMode
                  ? 'Tidak ada tugas dalam rentang ini'
                  : 'Tidak ada tugas untuk hari ini',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Sort: Pending first, then completed. If pending, overdue at bottom?
    // Actually per user request: "lewat -> redup -> bottom".
    // For a specific day's list, usually they all have same date.
    // So "lewat" means its date is < today and its still pending.
    filteredTodos.sort((a, b) {
      if (a['status'] == b['status']) return 0;
      return a['status'] == 'completed' ? 1 : -1;
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(Icons.list_alt, size: 18, color: Colors.cyan),
              const SizedBox(width: 8),
              Text(
                _isRangeMode ? 'Tugas dalam rentang' : 'Tugas Hari Ini',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.cyan),
              ),
              const Spacer(),
              Text('${filteredTodos.length} Tugas',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: filteredTodos.length,
            itemBuilder: (context, index) {
              final todo = filteredTodos[index];
              final isCompleted = todo['status'] == 'completed';
              final isOverdue =
                  !isCompleted && todo['date'].toString().compareTo(today) < 0;

              return Opacity(
                opacity: (isCompleted || isOverdue) ? 0.6 : 1.0,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 1,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: Container(
                      width: 4,
                      height: 24,
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
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                        color: isOverdue ? Colors.red[900] : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isRangeMode)
                          Text(todo['date'],
                              style: const TextStyle(fontSize: 12)),
                        Text(
                          'Prioritas: ${_translatePriority(todo['priority'])}',
                          style: TextStyle(
                              fontSize: 12,
                              color: _getPriorityColor(todo['priority'])),
                        ),
                      ],
                    ),
                    trailing: Checkbox(
                      value: isCompleted,
                      shape: const CircleBorder(),
                      activeColor: Colors.cyan,
                      onChanged: (value) async {
                        final response = await ApiService.updateTodo(
                          int.parse(todo['id'].toString()),
                          todo['title'],
                          todo['date'],
                          value! ? 'completed' : 'pending',
                        );
                        if (response['success']) widget.refreshTodos();
                      },
                    ),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Center(child: Text('Pilih Bulan & Tahun')),
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                        initialItem: selectedMonth - 1),
                    onSelectedItemChanged: (index) => selectedMonth = index + 1,
                    children: List.generate(12, (index) {
                      return Center(
                          child: Text(DateFormat('MMM')
                              .format(DateTime(2022, index + 1))));
                    }),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                        initialItem: selectedYear - startYear),
                    onSelectedItemChanged: (index) =>
                        selectedYear = startYear + index,
                    children: List.generate(endYear - startYear + 1, (index) {
                      return Center(child: Text('${startYear + index}'));
                    }),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text('Batal', style: TextStyle(color: Colors.grey))),
            TextButton(
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(selectedYear, selectedMonth, 1);
                  _selectedDay = DateTime(selectedYear, selectedMonth, 1);
                });
                Navigator.pop(context);
              },
              child: const Text('OK',
                  style: TextStyle(
                      color: Colors.cyan, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showAddTodoDialog() {
    final titleController = TextEditingController();
    String selectedPriority = 'medium';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Tambah Tugas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  labelText: 'Apa rencana Anda?', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: const InputDecoration(
                  labelText: 'Prioritas', border: OutlineInputBorder()),
              items: ['low', 'medium', 'high']
                  .map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(p == 'high'
                          ? 'Tinggi'
                          : p == 'medium'
                              ? 'Sedang'
                              : 'Rendah')))
                  .toList(),
              onChanged: (v) => selectedPriority = v!,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan, foregroundColor: Colors.white),
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                final date = DateFormat('yyyy-MM-dd')
                    .format(_selectedDay ?? _focusedDay);
                final response = await ApiService.createTodo(
                    titleController.text, date, selectedPriority);
                if (response['success']) {
                  if (!mounted) return;
                  Navigator.pop(context);
                  widget.refreshTodos();
                }
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
