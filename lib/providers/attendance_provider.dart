import 'package:flutter/foundation.dart';
import 'package:backtotrack/data/api_manager.dart';
import 'package:backtotrack/data/models/attendance_record.dart';

class AttendanceProvider with ChangeNotifier {
  List<AttendanceRecord> _records = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 0;
  final int _pageSize = 20;
  num? _totalRecords;
  num? _totalPages;
  DateTime _selectedDate = DateTime.now();
  String? _currentSearch;

  List<AttendanceRecord> get records => _records;
  bool get isLoading => _isLoading;
  String? get error => _error;
  num? get totalRecords => _totalRecords;
  DateTime get selectedDate => _selectedDate;
  bool get hasMore => _totalPages != null && _currentPage < _totalPages!;

  void setDate(DateTime date) {
    _selectedDate = date;
    fetchRecords(search: _currentSearch);
  }

  Future<void> fetchRecords({String? search, bool reset = true}) async {
    if (reset) {
      _currentPage = 0;
      _records = [];
      _totalRecords = null;
      _totalPages = null;
    }
    _currentSearch = search;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiManager.getAttendanceRecords(
        date: _formatDate(_selectedDate),
        search: _currentSearch,
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (response != null && response.content != null) {
        if (reset) {
          _records = response.content!;
        } else {
          _records.addAll(response.content!);
        }
        _totalRecords = response.totalElements;
        _totalPages = response.totalPages;
        _currentPage++;
      } else {
        _error = response?.message ?? 'Failed to fetch attendance records';
      }
    } catch (e) {
      _error = 'Error loading attendance records: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _formatDate(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }
}
