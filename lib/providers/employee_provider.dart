import 'package:flutter/foundation.dart';
import 'package:backtotrack/data/api_manager.dart';
import 'package:backtotrack/data/models/employee_data.dart';
import 'package:backtotrack/data/models/education_history.dart';
import 'package:backtotrack/data/models/position_history.dart';
import 'package:backtotrack/data/models/absence_request.dart';
import 'package:backtotrack/data/models/employees_list_response.dart';
import 'package:backtotrack/data/models/employee_response.dart';

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
  
  // Employees list state
  List<EmployeeData> _employeesList = [];
  bool _isEmployeesLoading = false;
  String? _employeesError;
  int _currentPage = 1;
  int _pageSize = 20;
  num? _totalEmployees;
  num? _totalPages;
  String? _currentSearch;
  int _employeesRequestId = 0;

  // Selected employee (details screen) state
  EmployeeData? _selectedEmployee;
  List<EducationHistory> _selectedEducationHistory = [];
  List<PositionHistory> _selectedPositionHistory = [];
  bool _isSelectedLoading = false;
  String? _selectedError;
  num? _selectedEmployeeId;

  EmployeeData? get selectedEmployee => _selectedEmployee;
  List<EducationHistory> get selectedEducationHistory => _selectedEducationHistory;
  List<PositionHistory> get selectedPositionHistory => _selectedPositionHistory;
  bool get isSelectedLoading => _isSelectedLoading;
  String? get selectedError => _selectedError;

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

  // Employees list getters
  List<EmployeeData> get employeesList => _employeesList;
  bool get isEmployeesLoading => _isEmployeesLoading;
  String? get employeesError => _employeesError;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  num? get totalEmployees => _totalEmployees;
  num? get totalPages => _totalPages;
  String? get currentSearch => _currentSearch;
  bool get hasMoreEmployees => _totalPages != null && _currentPage < _totalPages!;

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
    _selectedEmployeeId = null;
    _selectedEmployee = null;
    _selectedEducationHistory = [];
    _selectedPositionHistory = [];
    _isSelectedLoading = false;
    _selectedError = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _absenceError = null;
    notifyListeners();
  }

  Future<void> fetchEmployees({
    String? search,
    bool reset = true,
  }) async {
    if (reset) {
      _currentPage = 0;
      _employeesList = [];
      _currentSearch = search;
    } else {
      _currentSearch = search;
    }

    final requestId = ++_employeesRequestId;
    _isEmployeesLoading = true;
    _employeesError = null;
    notifyListeners();

    try {
      final response = await ApiManager.getEmployees(
        search: _currentSearch,
        page: _currentPage,
        pageSize: _pageSize,
      );
      if (requestId != _employeesRequestId) return;

      if (response != null && response.content != null) {
        if (reset) {
          _employeesList = response.content!;
        } else {
          _employeesList.addAll(response.content!);
        }
        _totalEmployees = response.totalElements;
        _totalPages = response.totalPages;
        _currentPage++;
        _employeesError = null;
      } else {
        _employeesError = response?.message ?? 'Failed to fetch employees';
      }
    } catch (e) {
      if (requestId == _employeesRequestId) {
        _employeesError = 'Error loading employees: $e';
      }
    } finally {
      if (requestId == _employeesRequestId) {
        _isEmployeesLoading = false;
        notifyListeners();
      }
    }
  }

  void clearEmployeesList() {
    _employeesRequestId++;
    _employeesList = [];
    _isEmployeesLoading = false;
    _currentPage = 0;
    _totalEmployees = null;
    _totalPages = null;
    _currentSearch = null;
    _employeesError = null;
    notifyListeners();
  }

  Future<void> fetchEmployeeById(num employeeId) async {
    if (_selectedEmployeeId != employeeId) {
      _selectedEmployee = null;
      _selectedEducationHistory = [];
      _selectedPositionHistory = [];
    }
    _selectedEmployeeId = employeeId;
    _isSelectedLoading = true;
    _selectedError = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        ApiManager.getEmployeeById(employeeId),
        ApiManager.getEducationHistory(employeeId),
        ApiManager.getPositionHistory(employeeId),
      ]);
      if (_selectedEmployeeId != employeeId) return;

      final response = results[0] as EmployeeResponse?;
      if (response != null && response.data != null) {
        _selectedEmployee = response.data;
        _selectedEducationHistory = results[1] as List<EducationHistory>;
        _selectedPositionHistory = results[2] as List<PositionHistory>;
      } else {
        _selectedError = response?.message ?? 'Failed to fetch employee data';
      }
    } catch (e) {
      if (_selectedEmployeeId == employeeId) {
        _selectedError = 'Error loading employee profile: $e';
      }
    } finally {
      if (_selectedEmployeeId == employeeId) {
        _isSelectedLoading = false;
        notifyListeners();
      }
    }
  }
}
