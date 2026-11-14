import 'package:flutter/foundation.dart';
import 'package:backtotrack/data/api_manager.dart';
import 'package:backtotrack/data/models/staff_evaluation.dart';

class StaffEvaluationProvider with ChangeNotifier {
  static const List<String> allForms = [
    'ADMINISTRATIVE',
    'ACADEMIC',
    'STUDENT_ACTIVITY',
    'QUALITY',
  ];

  static String formLabel(String? form) {
    switch (form) {
      case 'ADMINISTRATIVE':
        return 'Administrative';
      case 'ACADEMIC':
        return 'Academic';
      case 'STUDENT_ACTIVITY':
        return 'Student activities';
      case 'QUALITY':
        return 'Quality';
      default:
        return form ?? '';
    }
  }

  List<StaffEvaluation> _evaluations = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 0;
  final int _pageSize = 20;
  int _totalPages = 0;
  String? _filterForm;
  DateTime? _filterFrom;
  DateTime? _filterTo;

  List<EvaluationFormDefinition> _formDefinitions = [];
  List<Semester> _semesters = [];
  List<EvaluationCommittee> _committees = [];
  List<QualityStandard> _qualityStandards = [];
  List<Evaluatee> _evaluatees = [];
  bool _isFormDataLoading = false;
  bool _isEvaluateesLoading = false;
  bool _isSaving = false;

  List<StaffEvaluation> get evaluations => _evaluations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _currentPage + 1 < _totalPages;
  String? get filterForm => _filterForm;
  DateTime? get filterFrom => _filterFrom;
  DateTime? get filterTo => _filterTo;

  List<EvaluationFormDefinition> get formDefinitions => _formDefinitions;
  List<Semester> get semesters => _semesters;
  List<EvaluationCommittee> get committees => _committees;
  List<QualityStandard> get qualityStandards => _qualityStandards;
  List<Evaluatee> get evaluatees => _evaluatees;
  bool get isFormDataLoading => _isFormDataLoading;
  bool get isEvaluateesLoading => _isEvaluateesLoading;
  bool get isSaving => _isSaving;

  EvaluationFormDefinition? definitionFor(String form) {
    for (final d in _formDefinitions) {
      if (d.form == form) return d;
    }
    return null;
  }

  void setFilterForm(String? form) {
    _filterForm = form;
    fetchEvaluations();
  }

  void setFilterFrom(DateTime? date) {
    _filterFrom = date;
    fetchEvaluations();
  }

  void setFilterTo(DateTime? date) {
    _filterTo = date;
    fetchEvaluations();
  }

  Future<void> fetchEvaluations({bool reset = true}) async {
    if (_isLoading) return;
    if (reset) {
      _currentPage = 0;
    } else {
      if (!hasMore) return;
      _currentPage++;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiManager.getStaffEvaluations(
        form: _filterForm,
        from: _filterFrom != null ? formatDate(_filterFrom!) : null,
        to: _filterTo != null ? formatDate(_filterTo!) : null,
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (response != null && response.content != null) {
        if (reset) {
          _evaluations = response.content!;
        } else {
          _evaluations.addAll(response.content!);
        }
        _totalPages = (response.totalPages ?? 0).toInt();
      } else {
        if (reset) _evaluations = [];
        _error = response?.message ?? 'Failed to fetch evaluations';
      }
    } catch (e) {
      _error = 'Error loading evaluations: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFormData() async {
    if (_formDefinitions.isNotEmpty) return;
    _isFormDataLoading = true;
    notifyListeners();

    final results = await Future.wait([
      ApiManager.getEvaluationFormDefinitions(),
      ApiManager.getSemesters(),
      ApiManager.getEvaluationCommittees(),
      ApiManager.getQualityStandards(),
    ]);
    _formDefinitions = results[0] as List<EvaluationFormDefinition>;
    _semesters = results[1] as List<Semester>;
    _committees = (results[2] as List<EvaluationCommittee>).where((c) => c.active).toList();
    _qualityStandards = (results[3] as List<QualityStandard>).where((q) => q.active).toList();

    _isFormDataLoading = false;
    notifyListeners();
  }

  Future<void> searchEvaluatees(String search) async {
    _isEvaluateesLoading = true;
    notifyListeners();
    _evaluatees = await ApiManager.getEvaluatees(search: search);
    _isEvaluateesLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> saveEvaluation(Map<String, dynamic> body) async {
    _isSaving = true;
    notifyListeners();
    final result = await ApiManager.saveStaffEvaluation(body);
    _isSaving = false;
    notifyListeners();
    if (result['success'] == true) {
      fetchEvaluations();
    }
    return result;
  }

  static String formatDate(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }
}
