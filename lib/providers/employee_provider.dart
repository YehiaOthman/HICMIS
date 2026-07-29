import 'package:flutter/foundation.dart';
import 'package:backtotrack/data/api_manager.dart';
import 'package:backtotrack/data/models/employee_data.dart';
import 'package:backtotrack/data/models/education_history.dart';
import 'package:backtotrack/data/models/position_history.dart';
import 'package:backtotrack/data/models/absence_request.dart';

enum EmployeeStatus { initial, loading, loaded, error }

class EmployeeProvider with ChangeNotifier {
  EmployeeStatus _status = EmployeeStatus.initial;
  String? _errorMessage;
  EmployeeData? _employeeData;
  List<EducationHistory> _educationHistory = [];
  List<PositionHistory> _positionHistory = [];
  List<AbsenceRequest> _absenceRequests = [];
  bool _isAbsenceLoading = false;
  String? _absenceError;

  EmployeeStatus get status => _status;

  String? get errorMessage => _errorMessage;

  EmployeeData? get employeeData => _employeeData;

  List<EducationHistory> get educationHistory => _educationHistory;

  List<PositionHistory> get positionHistory => _positionHistory;

  List<AbsenceRequest> get absenceRequests => _absenceRequests;

  bool get isLoading => _status == EmployeeStatus.loading;

  bool get isLoaded => _status == EmployeeStatus.loaded;

  bool get isAbsenceLoading => _isAbsenceLoading;

  String? get absenceError => _absenceError;

  Future<void> fetchEmployeeProfile() async {
    _status = EmployeeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiManager.getProfile();
      if (response != null && response.data != null) {
        _employeeData = response.data;
        _errorMessage = null;
        _status = EmployeeStatus.loaded;

        if (_employeeData?.id != null) {
          await fetchEmployeeHistory(_employeeData!.id!);
        }
        await fetchMyAbsenceRequests();
      } else {
        _errorMessage = response?.message ?? 'Failed to fetch employee data';
        _status = EmployeeStatus.error;
      }
    } catch (e) {
      _errorMessage = 'Error loading employee profile: $e';
      _status = EmployeeStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchEmployeeHistory(num employeeId) async {
    try {
      final results = await Future.wait([
        ApiManager.getEducationHistory(employeeId),
        ApiManager.getPositionHistory(employeeId),
      ]);
      _educationHistory = results[0] as List<EducationHistory>;
      _positionHistory = results[1] as List<PositionHistory>;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading employee history: $e';
      notifyListeners();
    }
  }

  Future<void> refreshEmployeeData() async {
    if (_employeeData?.id != null) {
      await fetchEmployeeHistory(_employeeData!.id!);
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

  void clearEmployeeData() {
    _employeeData = null;
    _educationHistory = [];
    _positionHistory = [];
    _absenceRequests = [];
    _errorMessage = null;
    _absenceError = null;
    _status = EmployeeStatus.initial;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _absenceError = null;
    notifyListeners();
  }
}
