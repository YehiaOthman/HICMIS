import 'dart:convert';
import 'package:backtotrack/data/models/employee_response.dart';
import 'package:backtotrack/data/models/education_history.dart';
import 'package:backtotrack/data/models/position_history.dart';
import 'package:backtotrack/data/models/absence_request.dart';
import 'package:backtotrack/data/models/employees_list_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiManager {
  static const String baseUrl = 'hicims-api.goxtra.cloud';
  static const _storage = FlutterSecureStorage();

  static const String loginPath = '/api/auth/login';
  static const String refreshPath = '/api/auth/refresh';
  static const String forgotPasswordPath = '/api/auth/forgot-password';
  static const String profilePath = '/api/employees/me';
  static const String absenceRequestsPath = '/api/absence-requests';
  static const String employeesPath = '/api/employees';

  static String? _extractToken(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      if (data['token'] != null) return data['token'].toString();
      if (data['accessToken'] != null) return data['accessToken'].toString();
      if (data['access_token'] != null) return data['access_token'].toString();
      if (data['jwt'] != null) return data['jwt'].toString();
      if (data['data'] != null) return _extractToken(data['data']);
    }
    return null;
  }

  static String? _extractRefreshToken(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      if (data['refreshToken'] != null) return data['refreshToken'].toString();
      if (data['refresh_token'] != null)
        return data['refresh_token'].toString();
      if (data['data'] != null) return _extractRefreshToken(data['data']);
    }
    return null;
  }

  static Future<void> saveUsername(String username) async {
    await _storage.write(key: 'username', value: username);
  }

  static Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    Uri url = Uri.https(baseUrl, loginPath);

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'username': username, 'password': password}),
      );

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = {};
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        String? token = _extractToken(data);
        String? refreshToken = _extractRefreshToken(data);

        if (token != null) {
          await _storage.write(key: 'accessToken', value: token);
        }
        if (refreshToken != null) {
          await _storage.write(key: 'refreshToken', value: refreshToken);
        }
        await saveUsername(username);

        return {'success': true, 'data': data};
      } else {
        String message =
            data is Map
                ? (data['message'] ?? data['error'] ?? 'Login Failed')
                : 'Login Failed (${response.statusCode})';
        return {'success': false, 'message': message};
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        String? newToken = _extractToken(data);
        String? newRefreshToken = _extractRefreshToken(data);

        if (newToken != null) {
          await _storage.write(key: 'accessToken', value: newToken);
        }
        if (newRefreshToken != null) {
          await _storage.write(key: 'refreshToken', value: newRefreshToken);
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
        'message': data['message'] ?? 'Check your email for reset link',
      };
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
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

    if (token == null || token.isEmpty) {
      return EmployeeResponse(
        message: "No authentication token found. Please sign in again.",
      );
    }

    try {
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 401) {
        bool refreshed = await refreshToken();
        if (refreshed) {
          String? newToken = await getAccessToken();
          if (newToken != null && newToken.isNotEmpty) {
            response = await http.get(
              url,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $newToken",
              },
            );
          }
        }
      }

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data != null) {
          return EmployeeResponse.fromJson(data);
        } else {
          return EmployeeResponse(
            message: "Invalid response format from server.",
          );
        }
      } else {
        String msg =
            (data is Map && (data['message'] != null || data['error'] != null))
                ? (data['message'] ?? data['error']).toString()
                : "Server returned error status code: ${response.statusCode}";
        return EmployeeResponse(
          status: response.statusCode.toString(),
          message: msg,
        );
      }
    } catch (e) {
      return EmployeeResponse(message: "Connection exception: $e");
    }
  }

  static Future<List<EducationHistory>> getEducationHistory(
    num employeeId,
  ) async {
    Uri url = Uri.https(baseUrl, '/api/education/employee/$employeeId');
    String? token = await getAccessToken();

    if (token == null || token.isEmpty) return [];

    try {
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 401) {
        bool refreshed = await refreshToken();
        if (refreshed) {
          String? newToken = await getAccessToken();
          if (newToken != null && newToken.isNotEmpty) {
            response = await http.get(
              url,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $newToken",
              },
            );
          }
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        List rawList = [];
        if (data is List) {
          rawList = data;
        } else if (data is Map && data['data'] is List) {
          rawList = data['data'];
        }
        return rawList.map((item) => EducationHistory.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<PositionHistory>> getPositionHistory(
    num employeeId,
  ) async {
    Uri url = Uri.https(baseUrl, '/api/position-history/employee/$employeeId');
    String? token = await getAccessToken();

    if (token == null || token.isEmpty) return [];

    try {
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 401) {
        bool refreshed = await refreshToken();
        if (refreshed) {
          String? newToken = await getAccessToken();
          if (newToken != null && newToken.isNotEmpty) {
            response = await http.get(
              url,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $newToken",
              },
            );
          }
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        List rawList = [];
        if (data is List) {
          rawList = data;
        } else if (data is Map && data['data'] is List) {
          rawList = data['data'];
        }
        return rawList.map((item) => PositionHistory.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // --- ABSENCE REQUESTS ENDPOINTS ---

  static Future<Map<String, dynamic>> createAbsenceRequest({
    required String absenceType,
    required String startDate,
    required String endDate,
    required String reason,
    num? employeeId,
  }) async {
    Uri url = Uri.https(baseUrl, absenceRequestsPath);
    String? token = await getAccessToken();

    if (token == null || token.isEmpty) {
      return {'success': false, 'message': 'No authentication token found'};
    }

    // Map UI absence types to API format
    Map<String, String> absenceTypeMap = {
      'Annual Leave': 'ANNUAL_LEAVE',
      'Sick Leave': 'SICK_LEAVE',
      'Time Permission': 'TIME_PERMISSION',
      'Maternity Leave': 'MATERNITY_LEAVE',
      'Paternity Leave': 'PATERNITY_LEAVE',
      'Emergency Leave': 'EMERGENCY_LEAVE',
      'Unpaid Leave': 'UNPAID_LEAVE',
      'Bereavement Leave': 'BEREAVEMENT_LEAVE',
    };

    String apiAbsenceType = absenceTypeMap[absenceType] ?? 'ANNUAL_LEAVE';

    Map<String, dynamic> body = {
      'absenceType': apiAbsenceType,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
    };

    print('Creating absence request with body: ${jsonEncode(body)}');
    print('URL: $url');

    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 401) {
        bool refreshed = await refreshToken();
        if (refreshed) {
          String? newToken = await getAccessToken();
          if (newToken != null && newToken.isNotEmpty) {
            response = await http.post(
              url,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $newToken",
              },
              body: jsonEncode(body),
            );
          }
        }
      }

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = {};
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Leave request created successfully',
          'data': data,
        };
      } else {
        String msg =
            data is Map
                ? (data['message'] ??
                    data['error'] ??
                    'Failed to submit leave request')
                : 'Failed to submit leave request (${response.statusCode})';
        return {'success': false, 'message': msg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<List<AbsenceRequest>> getMyAbsenceRequests() async {
    Uri url = Uri.https(baseUrl, '$absenceRequestsPath/me');
    String? token = await getAccessToken();

    if (token == null || token.isEmpty) return [];

    try {
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 401) {
        bool refreshed = await refreshToken();
        if (refreshed) {
          String? newToken = await getAccessToken();
          if (newToken != null && newToken.isNotEmpty) {
            response = await http.get(
              url,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $newToken",
              },
            );
          }
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        List rawList = [];
        if (data is List) {
          rawList = data;
        } else if (data is Map && data['data'] is List) {
          rawList = data['data'];
        }
        return rawList.map((item) => AbsenceRequest.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> deleteAbsenceRequest(num id) async {
    Uri url = Uri.https(baseUrl, '$absenceRequestsPath/$id');
    String? token = await getAccessToken();

    print('Deleting absence request with ID: $id');
    print('URL: $url');

    if (token == null || token.isEmpty) {
      return {'success': false, 'message': 'No authentication token found'};
    }

    try {
      var response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 401) {
        bool refreshed = await refreshToken();
        if (refreshed) {
          String? newToken = await getAccessToken();
          if (newToken != null && newToken.isNotEmpty) {
            response = await http.delete(
              url,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $newToken",
              },
            );
          }
        }
      }

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = {};
      }

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Leave request deleted successfully',
        };
      } else {
        String msg =
            data is Map
                ? (data['message'] ??
                    data['error'] ??
                    'Failed to delete request')
                : 'Failed to delete request (${response.statusCode})';
        // Provide more specific error message for status-related issues
        if (msg.contains('status') || msg.contains('state')) {
          msg =
              'Cannot delete request - it may already be processed. Only pending requests can be deleted.';
        }
        return {'success': false, 'message': msg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<EmployeesListResponse?> getEmployees({
    String? search,
    int page = 0,
    int pageSize = 20,
  }) async {
    Uri url = Uri.https(baseUrl, employeesPath, {
      if (search != null && search.isNotEmpty) 'search': search,
      'page': page.toString(),
      'size': pageSize.toString(),
    });
    String? token = await getAccessToken();

    if (token == null || token.isEmpty) {
      return EmployeesListResponse(
        message: "No authentication token found. Please sign in again.",
      );
    }

    try {
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 401) {
        bool refreshed = await refreshToken();
        if (refreshed) {
          String? newToken = await getAccessToken();
          if (newToken != null && newToken.isNotEmpty) {
            response = await http.get(
              url,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $newToken",
              },
            );
          }
        }
      }

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data != null) {
          return EmployeesListResponse.fromJson(data);
        } else {
          return EmployeesListResponse(
            message: "Invalid response format from server.",
          );
        }
      } else {
        String msg =
            (data is Map && (data['message'] != null || data['error'] != null))
                ? (data['message'] ?? data['error']).toString()
                : "Server returned error status code: ${response.statusCode}";
        return EmployeesListResponse(
          status: response.statusCode.toString(),
          message: msg,
        );
      }
    } catch (e) {
      return EmployeesListResponse(message: "Connection exception: $e");
    }
  }

  static Future<EmployeeResponse?> getEmployeeById(num employeeId) async {
    Uri url = Uri.https(baseUrl, '$employeesPath/$employeeId');
    String? token = await getAccessToken();

    if (token == null || token.isEmpty) {
      return EmployeeResponse(
        message: "No authentication token found. Please sign in again.",
      );
    }

    try {
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 401) {
        bool refreshed = await refreshToken();
        if (refreshed) {
          String? newToken = await getAccessToken();
          if (newToken != null && newToken.isNotEmpty) {
            response = await http.get(
              url,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $newToken",
              },
            );
          }
        }
      }

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data != null) {
          return EmployeeResponse.fromJson(data);
        } else {
          return EmployeeResponse(
            message: "Invalid response format from server.",
          );
        }
      } else {
        String msg =
            (data is Map && (data['message'] != null || data['error'] != null))
                ? (data['message'] ?? data['error']).toString()
                : "Server returned error status code: ${response.statusCode}";
        return EmployeeResponse(
          status: response.statusCode.toString(),
          message: msg,
        );
      }
    } catch (e) {
      return EmployeeResponse(message: "Connection exception: $e");
    }
  }
}
