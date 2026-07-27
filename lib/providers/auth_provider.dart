import 'package:flutter/foundation.dart';
import 'package:backtotrack/data/api_manager.dart';
import 'package:backtotrack/data/models/employee_data.dart';
import 'package:backtotrack/data/models/education_history.dart';
import 'package:backtotrack/data/models/position_history.dart';

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
  bool _isProfileLoading = false;
  String? _profileError;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get username => _username;
  EmployeeData? get employeeData => _employeeData;
  List<EducationHistory> get educationHistory => _educationHistory;
  List<PositionHistory> get positionHistory => _positionHistory;
  bool get isProfileLoading => _isProfileLoading;
  String? get profileError => _profileError;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

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

  Future<bool> login(String username, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiManager.login(username, password);

    if (result['success']) {
      _status = AuthStatus.authenticated;
      _username = username;
      notifyListeners();
      await fetchProfile();
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
    _errorMessage = null;
    _profileError = null;
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    final token = await ApiManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      _username = await ApiManager.getUsername();
      _status = AuthStatus.authenticated;
      notifyListeners();
      await fetchProfile();
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


