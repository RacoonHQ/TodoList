import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static String _baseUrl = 'https://sayyid.bersama.cloud/api';
  static String? _authToken;

  static void setBaseUrl(String url) {
    _baseUrl = url;
  }

  static void setAuthToken(String token) {
    _authToken = token;
  }

  static Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login.php'),
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final responseData = data['data'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', responseData['token'] ?? '');
          await prefs.setInt(
              'user_id', int.tryParse(responseData['user_id'].toString()) ?? 0);
          await prefs.setString('user_name', responseData['name'] ?? '');
          await prefs.setString('user_email', email);
          await prefs.setString('user_photo', responseData['photo'] ?? '');
          await prefs.setString(
              'user_created_at', responseData['created_at'] ?? '');
          setAuthToken(responseData['token'] ?? '');
          return {'success': true, 'data': responseData};
        } else {
          return {'success': false, 'message': data['message']};
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register.php'),
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final responseData = data['data'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', responseData['token'] ?? '');
          await prefs.setInt(
              'user_id', int.tryParse(responseData['user_id'].toString()) ?? 0);
          await prefs.setString('user_name', responseData['name'] ?? '');
          await prefs.setString('user_email', email);
          await prefs.setString('user_photo', responseData['photo'] ?? '');
          await prefs.setString(
              'user_created_at', responseData['created_at'] ?? '');
          setAuthToken(responseData['token'] ?? '');
          return {'success': true, 'data': responseData};
        } else {
          return {'success': false, 'message': data['message']};
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getTodos(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/todos/index.php?user_id=$userId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final todos = data['data']?['todos'] ?? [];
          return {'success': true, 'data': todos};
        } else {
          return {'success': false, 'message': data['message']};
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> createTodo(
      String title, String date, String priority) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      final response = await http.post(
        Uri.parse('$_baseUrl/todos/create.php'),
        headers: _getHeaders(),
        body: jsonEncode({
          'user_id': userId,
          'title': title,
          'date': date,
          'priority': priority,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': data['success'],
          'message': data['message'],
          'data': data['todo']
        };
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateTodo(
      int id, String title, String date, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/todos/update.php'),
        headers: _getHeaders(),
        body: jsonEncode({
          'id': id,
          'title': title,
          'date': date,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': data['success'], 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteTodo(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/todos/delete.php?id=$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': data['success'], 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getNotes(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/notes/index.php?user_id=$userId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final notes = data['data']?['notes'] ?? [];
          return {'success': true, 'data': notes};
        } else {
          return {'success': false, 'message': data['message']};
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> createNote(String title, String content,
      {String? imageUrl}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      final response = await http.post(
        Uri.parse('$_baseUrl/notes/create.php'),
        headers: _getHeaders(),
        body: jsonEncode({
          'user_id': userId,
          'title': title,
          'content': content,
          if (imageUrl != null) 'image_url': imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': data['success'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> uploadNoteImage(XFile imageFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/notes/upload_image.php'),
      );

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      // Support for both Web and Mobile
      final bytes = await imageFile.readAsBytes();
      final extension = imageFile.name.split('.').last.toLowerCase();
      String mimeType = 'jpeg';
      if (extension == 'png') mimeType = 'png';
      if (extension == 'gif') mimeType = 'gif';
      
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: imageFile.name,
        contentType: MediaType('image', mimeType),
      ));

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return {
            'success': true,
            'image_url': data['image_url'],
            'message': data['message']
          };
        } else {
          return {'success': false, 'message': data['message']};
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteNote(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/notes/delete.php'),
        headers: _getHeaders(),
        body: jsonEncode({'id': id}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': data['success'], 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateProfile(
      String? name, String? password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      final body = <String, dynamic>{'user_id': userId};
      if (name != null) body['name'] = name;
      if (password != null) body['password'] = password;

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/update_profile.php'),
        headers: _getHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] && name != null) {
          await prefs.setString('user_name', name);
        }
        return {'success': data['success'], 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> uploadProfilePhoto(XFile xFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      var request = http.MultipartRequest(
          'POST', Uri.parse('$_baseUrl/auth/upload_photo.php'));
      request.headers.addAll({
        'Accept': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      });

      request.fields['user_id'] = userId.toString();

      // Support for both Web and Mobile
      final bytes = await xFile.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'photo',
        bytes,
        filename: xFile.name,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] && data['data'] != null) {
          final String photoUrl = data['data']['photo_url'] ?? '';
          await prefs.setString('user_photo', photoUrl);
          return {
            'success': true,
            'message': data['message'],
            'photo_url': photoUrl
          };
        }
        return {'success': false, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': 'Server error: ${streamedResponse.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      await prefs.remove('user_created_at');
      _authToken = null;
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
