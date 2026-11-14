import 'package:flutter/foundation.dart';
import 'package:backtotrack/data/api_manager.dart';
import 'package:backtotrack/data/models/employee_data.dart';
import 'package:backtotrack/data/models/education_history.dart';
import 'package:backtotrack/data/models/position_history.dart';
import 'package:backtotrack/data/models/absence_request.dart';
import 'package:jwt_decode/jwt_decode.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  String? _username;
  EmployeeData? _employeeData;
  List<EducationHistory> _educationHistory = [];
  List<PositionHistory> _positionHistory = [];
  List<AbsenceRequest> _absenceRequests = [];
  bool _isProfileLoading = false;
  bool _isAbsenceLoading = false;
  String? _profileError;
  String? _absenceError;
  String? _userRole;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get username => _username;
  EmployeeData? get employeeData => _employeeData;
  List<EducationHistory> get educationHistory => _educationHistory;
  List<PositionHistory> get positionHistory => _positionHistory;
  List<AbsenceRequest> get absenceRequests => _absenceRequests;
  bool get isProfileLoading => _isProfileLoading;
  bool get isAbsenceLoading => _isAbsenceLoading;
  String? get profileError => _profileError;
  String? get absenceError => _absenceError;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  String? get userRole => _userRole;
  bool get isHR => _userRole == 'hr';
  bool get isManager => _userRole == 'manager';
  bool get isEmployee => _userRole == 'employee';
  bool get isAcademicObserver => _userRole == 'academic_observer';

  Future<void> _extractUserRoleFromToken() async {
    final token = await ApiManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      try {
        final decodedToken = Jwt.parseJwt(token);
        if (decodedToken is Map && decodedToken['resource_access'] is Map) {
          final resourceAccess = decodedToken['resource_access'] as Map;
          if (resourceAccess['HICMIS_BE_CLIENT'] is Map) {
            final clientData = resourceAccess['HICMIS_BE_CLIENT'] as Map;
            if (clientData['roles'] is List) {
              final roles = clientData['roles'] as List;
              if (roles.contains('manager')) {
                _userRole = 'manager';
              } else if (roles.contains('hr')) {
                _userRole = 'hr';
              } else if (roles.contains('academic_observer')) {
                _userRole = 'academic_observer';
              } else if (roles.contains('employee')) {
                _userRole = 'employee';
              }
            }
          }
        }
      } catch (e) {
        print('Error decoding JWT token: $e');
      }
    }
  }

  Future<void> fetchProfile() async {
    _isProfileLoading = true;
    _profileError = null;
    notifyListeners();

    try {
      final response = await ApiManager.getProfile();
      if (response != null && response.data != null) {
        _employeeData = response.data;
        _profileError = null;

        if (_employeeData?.id != null) {
          final results = await Future.wait([
            ApiManager.getEducationHistory(_employeeData!.id!),
            ApiManager.getPositionHistory(_employeeData!.id!),
          ]);
          _educationHistory = results[0] as List<EducationHistory>;
          _positionHistory = results[1] as List<PositionHistory>;
        }
      } else {
        _profileError = response?.message ?? 'Failed to fetch profile data';
      }
    } catch (e) {
      _profileError = 'Error loading profile: $e';
    } finally {
      _isProfileLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyAbsenceRequests() async {
    _isAbsenceLoading = true;
    _absenceError = null;
    notifyListeners();

    try {
      final list = await ApiManager.getMyAbsenceRequests();
      _absenceRequests = list;
      _absenceError = null;
    } catch (e) {
      _absenceError = 'Failed to load leave requests: $e';
    } finally {
      _isAbsenceLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createAbsenceRequest({
    required String absenceType,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    _isAbsenceLoading = true;
    notifyListeners();

    final result = await ApiManager.createAbsenceRequest(
      absenceType: absenceType,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      employeeId: _employeeData?.id,
    );

    if (result['success']) {
      await fetchMyAbsenceRequests();
    } else {
      _isAbsenceLoading = false;
      notifyListeners();
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteAbsenceRequest(num id) async {
    final result = await ApiManager.deleteAbsenceRequest(id);

    if (result['success']) {
      _absenceRequests.removeWhere((item) => item.id == id);
      notifyListeners();
    }

    return result;
  }

  Future<bool> login(String username, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiManager.login(username, password);

    if (result['success']) {
      _status = AuthStatus.authenticated;
      _username = username;
      notifyListeners();
      await _extractUserRoleFromToken();
      return true;
    } else {
      _status = AuthStatus.error;
      _errorMessage = result['message'] ?? 'Login failed';
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiManager.forgotPassword(email);

    if (result['success']) {
      _status = AuthStatus.initial;
      notifyListeners();
      return true;
    } else {
      _status = AuthStatus.error;
      _errorMessage = result['message'] ?? 'Failed to send reset email';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();

    await ApiManager.logout();

    _status = AuthStatus.unauthenticated;
    _username = null;
    _employeeData = null;
    _educationHistory = [];
    _positionHistory = [];
    _absenceRequests = [];
    _errorMessage = null;
    _profileError = null;
    _absenceError = null;
    _userRole = null;
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    final token = await ApiManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      _username = await ApiManager.getUsername();
      _status = AuthStatus.authenticated;
      notifyListeners();
      await _extractUserRoleFromToken();
      return true;
    }
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return false;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}



