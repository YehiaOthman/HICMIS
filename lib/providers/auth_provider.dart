import 'package:flutter/foundation.dart';
import 'package:backtotrack/data/api_manager.dart';

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

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get username => _username;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  Future<bool> login(String username, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiManager.login(username, password);

    if (result['success']) {
      _status = AuthStatus.authenticated;
      _username = username;
      notifyListeners();
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
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    final token = await ApiManager.getAccessToken();
    if (token != null) {
      _status = AuthStatus.authenticated;
      notifyListeners();
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
