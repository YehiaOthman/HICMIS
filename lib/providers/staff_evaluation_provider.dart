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
  int _requestId = 0;
  int _evaluateesRequestId = 0;

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
    if (!reset && (_isLoading || !hasMore)) return;
    final page = reset ? 0 : _currentPage + 1;
    final requestId = ++_requestId;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiManager.getStaffEvaluations(
        form: _filterForm,
        from: _filterFrom != null ? formatDate(_filterFrom!) : null,
        to: _filterTo != null ? formatDate(_filterTo!) : null,
        page: page,
        pageSize: _pageSize,
      );
      if (requestId != _requestId) return;

      if (response != null && response.content != null) {
        _currentPage = page;
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
      if (requestId == _requestId) {
        _error = 'Error loading evaluations: $e';
      }
    } finally {
      if (requestId == _requestId) {
        _isLoading = false;
        notifyListeners();
      }
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
    final requestId = ++_evaluateesRequestId;
    _isEvaluateesLoading = true;
    notifyListeners();
    final result = await ApiManager.getEvaluatees(search: search);
    if (requestId != _evaluateesRequestId) return;
    _evaluatees = result;
    _isEvaluateesLoading = false;
    notifyListeners();
  }

  void clear() {
    _requestId++;
    _evaluateesRequestId++;
    _evaluations = [];
    _isLoading = false;
    _error = null;
    _currentPage = 0;
    _totalPages = 0;
    _filterForm = null;
    _filterFrom = null;
    _filterTo = null;
    _evaluatees = [];
    _isEvaluateesLoading = false;
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
