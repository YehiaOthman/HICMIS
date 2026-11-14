import 'package:flutter/foundation.dart';
import 'package:backtotrack/data/api_manager.dart';
import 'package:backtotrack/data/models/department.dart';
import 'package:backtotrack/data/models/daily_attendance_report.dart';

class DailyAttendanceProvider with ChangeNotifier {
  static const List<String> allStatuses = [
    'COMPLETE_DAY',
    'IN_PROGRESS',
    'VACATION',
    'HALF_DAY_DEDUCTION',
    'FULL_DAY_DEDUCTION',
    'NON_WORKING_DAY',
  ];

  DailyAttendanceReport? _report;
  bool _isLoading = false;
  String? _error;
  DateTime _selectedDate = DateTime.now();
  num? _departmentId;
  final Set<String> _selectedStatuses = {};
  List<Department> _departments = [];
  int _requestId = 0;

  DailyAttendanceReport? get report => _report;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;
  num? get departmentId => _departmentId;
  Set<String> get selectedStatuses => _selectedStatuses;
  List<Department> get departments => _departments;

  void setDate(DateTime date) {
    _selectedDate = date;
    fetchReport();
  }

  void setDepartment(num? id) {
    _departmentId = id;
    fetchReport();
  }

  void toggleStatus(String status) {
    if (!_selectedStatuses.remove(status)) {
      _selectedStatuses.add(status);
    }
    fetchReport();
  }

  void clearFilters() {
    _departmentId = null;
    _selectedStatuses.clear();
    fetchReport();
  }

  Future<void> fetchDepartments() async {
    if (_departments.isNotEmpty) return;
    _departments = await ApiManager.getDepartments();
    notifyListeners();
  }

  Future<void> fetchReport() async {
    final requestId = ++_requestId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiManager.getDailyAttendanceReport(
        date: _formatDate(_selectedDate),
        departmentId: _departmentId,
        statuses: _selectedStatuses.toList(),
      );
      if (requestId != _requestId) return;

      if (response != null && response.data != null) {
        _report = response.data;
      } else {
        _report = null;
        _error = response?.message ?? 'Failed to fetch daily attendance';
      }
    } catch (e) {
      if (requestId == _requestId) {
        _report = null;
        _error = 'Error loading daily attendance: $e';
      }
    } finally {
      if (requestId == _requestId) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void clear() {
    _requestId++;
    _report = null;
    _isLoading = false;
    _error = null;
    _selectedDate = DateTime.now();
    _departmentId = null;
    _selectedStatuses.clear();
  }

  String _formatDate(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }
}
