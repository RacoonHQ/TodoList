import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'pages/calendar_page.dart';
import 'pages/todos_page.dart';
import 'pages/notes_page.dart';
import 'pages/profile_page.dart';
import 'auth/login_page.dart';
import 'auth/register_page.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  List<Map<String, dynamic>> _todos = [];
  List<Map<String, dynamic>> _notes = [];
  String _userName = '';
  String _userEmail = '';
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUserData();
    _loadTodos();
    _loadNotes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? '';
      _userEmail = prefs.getString('user_email') ?? '';
      _userId = prefs.getInt('user_id') ?? 0;
    });
  }

  Future<void> _loadTodos() async {
    try {
      print('Loading todos for user ID: $_userId');
      final response = await ApiService.getTodos(_userId);
      print('API response: $response');
      if (response['success'] && response['data'] != null) {
        setState(() {
          _todos = List<Map<String, dynamic>>.from(response['data'] ?? []);
          print('Todos loaded: ${_todos.length} items');
        });
      } else {
        print('Failed to load todos: ${response['message']}');
      }
    } catch (e) {
      print('Error loading todos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading todos: $e')),
      );
    }
  }

  Future<void> _loadNotes() async {
    try {
      print('Loading notes for user ID: $_userId');
      final response = await ApiService.getNotes(_userId);
      if (response['success'] && response['data'] != null) {
        setState(() {
          _notes = List<Map<String, dynamic>>.from(response['data'] ?? []);
        });
      }
    } catch (e) {
      print('Error loading notes: $e');
    }
  }

  Future<void> _logout() async {
    await ApiService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  List<Widget> _buildTabs() {
    return [
      CalendarPage(todos: _todos, refreshTodos: _loadTodos),
      TodosPage(todos: _todos, refreshTodos: _loadTodos),
      NotesPage(articles: _notes, refreshNotes: _loadNotes),
      ProfilePage(
        userName: _userName,
        userId: _userId,
        userEmail: _userEmail,
        logout: _logout,
      ),
    ];
  }

  // List of page titles corresponding to each tab
  final List<String> _pageTitles = [
    'Kalender',
    'Daftar Tugas',
    'Catatan',
    'Profil'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _pageTitles[_currentIndex],
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  _userName.isNotEmpty ? _userName : 'Pengguna',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.person, color: Colors.white, size: 24),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.cyan,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        controller: _tabController,
        children: _buildTabs(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _tabController.animateTo(index);
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            activeIcon: Icon(Icons.checklist),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            activeIcon: Icon(Icons.note_alt),
            label: 'Catatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  void _toggleAuth() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLogin
        ? LoginPage(toggleAuth: _toggleAuth)
        : RegisterPage(toggleAuth: _toggleAuth);
  }
}
