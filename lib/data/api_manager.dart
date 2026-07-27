import 'dart:convert';
import 'package:backtotrack/data/models/employee_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiManager {
  static const String baseUrl = 'hicims-api.goxtra.cloud';
  static const _storage = FlutterSecureStorage();

  static const String loginPath = '/api/auth/login';
  static const String refreshPath = '/api/auth/refresh';
  static const String forgotPasswordPath = '/api/auth/forgot-password';
  static const String profilePath = '/api/employees/me';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    Uri url = Uri.https(baseUrl, loginPath);

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['token'] != null) {
          await _storage.write(key: 'accessToken', value: data['token']);
        }
        if (data['refreshToken'] != null) {
          await _storage.write(key: 'refreshToken', value: data['refreshToken']);
        }

        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login Failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<bool> refreshToken() async {
    Uri url = Uri.https(baseUrl, refreshPath);
    String? storedRefreshToken = await _storage.read(key: 'refreshToken');

    if (storedRefreshToken == null) return false;

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'refreshToken': storedRefreshToken}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        await _storage.write(key: 'accessToken', value: data['token']);
        if (data['refreshToken'] != null) {
          await _storage.write(key: 'refreshToken', value: data['refreshToken']);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    Uri url = Uri.https(baseUrl, forgotPasswordPath);

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email}),
      );

      var data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'message': data['message'] ?? 'Check your email for reset link'
      };
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }

  static Future<EmployeeResponse?> getProfile() async {
    Uri url = Uri.https(baseUrl, profilePath);
    String? token = await getAccessToken();

    if (token == null) return null;

    try {
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return EmployeeResponse.fromJson(data);
      } else {
        print("Profile Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Profile Exception: $e");
      return null;
    }
  }
  static const String employeeMePath = '/api/employees/me';


}