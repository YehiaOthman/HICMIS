import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/screens/home/widgets/app_drawer.dart';
import 'package:backtotrack/providers/staff_evaluation_provider.dart';
import 'package:backtotrack/data/models/staff_evaluation.dart';

const _primary = Color(0xFF2353D0);
const _textDark = Color(0xFF1E293B);
const _textMuted = Color(0xFF475569);

class StaffEvaluationsScreen extends StatefulWidget {
  const StaffEvaluationsScreen({super.key});

  @override
  State<StaffEvaluationsScreen> createState() => _StaffEvaluationsScreenState();
}

class _StaffEvaluationsScreenState extends State<StaffEvaluationsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<StaffEvaluationProvider>(context, listen: false);
      provider.fetchEvaluations();
      provider.fetchFormData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      drawer: const AppDrawer(currentRoute: '/staff-evaluations'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: _textMuted, size: 22.r),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(8.r)),
              child: Icon(Icons.home_filled, color: Colors.white, size: 20.r),
            ),
            SizedBox(width: 10.w),
            Text('HICMIS', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Staff Evaluations', style: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                Text(
                  'Administrative, academic, student-activity and quality evaluation forms.',
                  style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: _primary,
            unselectedLabelColor: _textMuted,
            indicatorColor: _primary,
            labelStyle: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600),
            tabs: const [Tab(text: 'Evaluations'), Tab(text: 'New evaluation')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const _EvaluationsList(),
                _NewEvaluationForm(onDone: () => _tabController.animateTo(0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EvaluationsList extends StatefulWidget {
  const _EvaluationsList();

  @override
  State<_EvaluationsList> createState() => _EvaluationsListState();
}

class _EvaluationsListState extends State<_EvaluationsList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        Provider.of<StaffEvaluationProvider>(context, listen: false).fetchEvaluations(reset: false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickFilterDate(bool isFrom) async {
    final provider = Provider.of<StaffEvaluationProvider>(context, listen: false);
    final current = isFrom ? provider.filterFrom : provider.filterTo;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    if (isFrom) {
      provider.setFilterFrom(picked);
    } else {
      provider.setFilterTo(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<StaffEvaluationProvider>(
      builder: (context, provider, child) {
        final items = provider.evaluations;
        return RefreshIndicator(
          onRefresh: () => provider.fetchEvaluations(),
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(20.r),
            children: [
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Form'),
                    _dropdown<String?>(
                      value: provider.filterForm,
                      items: [
                        _menuItem<String?>(null, 'All forms'),
                        ...StaffEvaluationProvider.allForms.map((f) => _menuItem<String?>(f, StaffEvaluationProvider.formLabel(f))),
                      ],
                      onChanged: provider.setFilterForm,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('From'),
                              _dateBox(
                                provider.filterFrom,
                                onTap: () => _pickFilterDate(true),
                                onClear: provider.filterFrom != null ? () => provider.setFilterFrom(null) : null,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('To'),
                              _dateBox(
                                provider.filterTo,
                                onTap: () => _pickFilterDate(false),
                                onClear: provider.filterTo != null ? () => provider.setFilterTo(null) : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              if (provider.isLoading && items.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: const Center(child: CircularProgressIndicator(color: _primary)),
                )
              else if (items.isEmpty)
                _card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.h),
                    child: Center(
                      child: Text(
                        provider.error ?? 'No evaluations found.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else ...[
                ...items.map(_buildEvaluationCard),
                if (provider.isLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: const Center(child: CircularProgressIndicator(color: _primary)),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEvaluationCard(StaffEvaluation e) {
    final score = e.totalScore != null && e.maxScore != null ? '${_num(e.totalScore)} / ${_num(e.maxScore)}' : '-';
    String? extra;
    if (e.committeeName != null) extra = e.committeeName;
    if (e.qualityStandardName != null) {
      extra = '${e.qualityStandardNumber != null ? '${e.qualityStandardNumber}. ' : ''}${e.qualityStandardName}';
    }
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    e.employeeName ?? 'Unknown',
                    style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600, color: _textDark),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    StaffEvaluationProvider.formLabel(e.form),
                    style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w600, color: _primary),
                  ),
                ),
              ],
            ),
            if (extra != null) ...[
              SizedBox(height: 4.h),
              Text(extra, style: GoogleFonts.poppins(fontSize: 11.sp, color: _textMuted)),
            ],
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(child: _info('Date', e.evaluationDate ?? '-')),
                Expanded(child: _info('Semester', e.semesterLabel ?? '-')),
                Expanded(child: _info('Score', score)),
              ],
            ),
            if (e.evaluatorName != null) ...[
              SizedBox(height: 10.h),
              _info('Evaluator', e.evaluatorName!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 10.sp, color: const Color(0xFF94A3B8))),
        SizedBox(height: 2.h),
        Text(value, style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: _textMuted)),
      ],
    );
  }

  String _num(num? v) {
    if (v == null) return '-';
    return v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);
  }
}

class _NewEvaluationForm extends StatefulWidget {
  final VoidCallback onDone;

  const _NewEvaluationForm({required this.onDone});

  @override
  State<_NewEvaluationForm> createState() => _NewEvaluationFormState();
}

class _NewEvaluationFormState extends State<_NewEvaluationForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _form = StaffEvaluationProvider.allForms.first;
  num? _employeeId;
  DateTime _evaluationDate = DateTime.now();
  num? _semesterId;
  num? _committeeId;
  num? _qualityStandardId;
  final Map<String, String> _answers = {};
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  int _resetVersion = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StaffEvaluationProvider>(context, listen: false).searchEvaluatees('');
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Provider.of<StaffEvaluationProvider>(context, listen: false).searchEvaluatees(value.trim());
    });
  }

  void _reset() {
    setState(() {
      _employeeId = null;
      _evaluationDate = DateTime.now();
      _committeeId = null;
      _qualityStandardId = null;
      _answers.clear();
      _searchController.clear();
      _resetVersion++;
    });
    Provider.of<StaffEvaluationProvider>(context, listen: false).searchEvaluatees('');
  }

  bool _isVisible(EvaluationField field) {
    if (field.dependsOn == null || field.dependsOn!.isEmpty) return true;
    final current = _answers[field.dependsOn!];
    if (current == null) return false;
    if (field.dependsOnValue == null || field.dependsOnValue!.isEmpty) return current.isNotEmpty;
    return field.dependsOnValue!.split(',').map((v) => v.trim()).contains(current);
  }

  List<List<EvaluationField>> _groupFields(List<EvaluationField> fields) {
    final groups = <List<EvaluationField>>[];
    String? lastGroup;
    for (final field in fields) {
      if (field.group != null && field.group == lastGroup && groups.isNotEmpty) {
        groups.last.add(field);
      } else {
        groups.add([field]);
      }
      lastGroup = field.group;
    }
    return groups;
  }

  Future<void> _save(StaffEvaluationProvider provider, EvaluationFormDefinition? definition) async {
    final missing = <String>[];
    if (_employeeId == null) missing.add('Staff member');
    if (definition != null && definition.needsCommittee && _committeeId == null) missing.add('Committee');
    if (definition != null && definition.needsStandard && _qualityStandardId == null) missing.add('Quality standard');

    final answers = <Map<String, String>>[];
    for (final field in definition?.fields ?? <EvaluationField>[]) {
      if (field.key == null || !_isVisible(field)) continue;
      final value = _answers[field.key!]?.trim() ?? '';
      if (value.isEmpty) {
        if (field.required) missing.add(field.labelEn ?? field.key!);
        continue;
      }
      answers.add({'field': field.key!, 'value': value});
    }

    if (missing.isNotEmpty) {
      _showMessage('Please fill: ${missing.join(', ')}');
      return;
    }

    final body = <String, dynamic>{
      'form': _form,
      'employeeId': _employeeId,
      'evaluationDate': StaffEvaluationProvider.formatDate(_evaluationDate),
      if (_semesterId != null) 'semesterId': _semesterId,
      if (definition != null && definition.needsCommittee) 'committeeId': _committeeId,
      if (definition != null && definition.needsStandard) 'qualityStandardId': _qualityStandardId,
      'answers': answers,
    };

    final result = await provider.saveEvaluation(body);
    if (!mounted) return;
    if (result['success'] == true) {
      _showMessage('Evaluation saved');
      _reset();
      widget.onDone();
    } else {
      _showMessage(result['message']?.toString() ?? 'Failed to save evaluation');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp)),
        backgroundColor: _primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<StaffEvaluationProvider>(
      builder: (context, provider, child) {
        if (provider.isFormDataLoading && provider.formDefinitions.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: _primary));
        }

        if (_semesterId == null && provider.semesters.isNotEmpty) {
          final active = provider.semesters.where((s) => s.active);
          _semesterId = (active.isNotEmpty ? active.first : provider.semesters.first).id;
        }

        final definition = provider.definitionFor(_form);
        final evaluatees = provider.evaluatees;
        final selectedInList = evaluatees.any((e) => e.employeeId == _employeeId);

        return ListView(
          padding: EdgeInsets.all(20.r),
          children: [
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Form'),
                  _dropdown<String>(
                    value: _form,
                    items: StaffEvaluationProvider.allForms
                        .map((f) => _menuItem<String>(f, StaffEvaluationProvider.formLabel(f)))
                        .toList(),
                    onChanged: (v) {
                      if (v == null || v == _form) return;
                      setState(() {
                        _form = v;
                        _answers.clear();
                        _committeeId = null;
                        _qualityStandardId = null;
                        _resetVersion++;
                      });
                    },
                  ),
                  SizedBox(height: 12.h),
                  _label('Staff member', required: true),
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: GoogleFonts.poppins(fontSize: 13.sp),
                    decoration: _inputDecoration('Search by name or code').copyWith(
                      prefixIcon: Icon(Icons.search, size: 20.r, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _dropdown<num?>(
                    value: selectedInList ? _employeeId : null,
                    items: [
                      _menuItem<num?>(null, provider.isEvaluateesLoading ? 'Loading...' : '-- Select staff member --'),
                      ...evaluatees.map((e) => _menuItem<num?>(
                            e.employeeId,
                            '${e.name ?? ''}${e.empCode != null ? ' (${e.empCode})' : ''}',
                          )),
                    ],
                    onChanged: (v) => setState(() => _employeeId = v),
                  ),
                  SizedBox(height: 12.h),
                  _label('Evaluation date'),
                  _dateBox(
                    _evaluationDate,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _evaluationDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _evaluationDate = picked);
                    },
                  ),
                  SizedBox(height: 12.h),
                  _label('Semester'),
                  _dropdown<num?>(
                    value: provider.semesters.any((s) => s.id == _semesterId) ? _semesterId : null,
                    items: [
                      if (provider.semesters.isEmpty) _menuItem<num?>(null, '-- No semesters --'),
                      ...provider.semesters.map((s) => _menuItem<num?>(s.id, s.label ?? '')),
                    ],
                    onChanged: (v) => setState(() => _semesterId = v),
                  ),
                  if (definition != null && definition.needsCommittee) ...[
                    SizedBox(height: 12.h),
                    _label('Committee', required: true),
                    _dropdown<num?>(
                      value: _committeeId,
                      items: [
                        _menuItem<num?>(null, '-- Select committee --'),
                        ...provider.committees.map((c) => _menuItem<num?>(c.id, c.nameEn ?? c.nameAr ?? '')),
                      ],
                      onChanged: (v) => setState(() => _committeeId = v),
                    ),
                  ],
                  if (definition != null && definition.needsStandard) ...[
                    SizedBox(height: 12.h),
                    _label('Quality standard', required: true),
                    _dropdown<num?>(
                      value: _qualityStandardId,
                      items: [
                        _menuItem<num?>(null, '-- Select quality standard --'),
                        ...provider.qualityStandards.map((q) => _menuItem<num?>(
                              q.id,
                              '${q.number != null ? '${q.number}. ' : ''}${q.nameEn ?? q.nameAr ?? ''}',
                            )),
                      ],
                      onChanged: (v) => setState(() => _qualityStandardId = v),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 15.h),
            if (definition == null)
              _card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  child: Center(
                    child: Text(
                      'Could not load the questions for this form.',
                      style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.grey),
                    ),
                  ),
                ),
              )
            else
              ..._groupFields(definition.fields).map((group) {
                final visible = group.where(_isVisible).toList();
                if (visible.isEmpty) return const SizedBox.shrink();
                return Container(
                  margin: EdgeInsets.only(bottom: 15.h),
                  child: _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < visible.length; i++) ...[
                          if (i > 0) SizedBox(height: 12.h),
                          _buildField(visible[i]),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: provider.isSaving
                      ? null
                      : () {
                          _reset();
                          widget.onDone();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A6C2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 13.sp)),
                ),
                SizedBox(width: 10.w),
                ElevatedButton.icon(
                  onPressed: provider.isSaving ? null : () => _save(provider, definition),
                  icon: provider.isSaving
                      ? SizedBox(width: 16.r, height: 16.r, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Icon(Icons.check, size: 18.r),
                  label: Text('Save', style: GoogleFonts.poppins(fontSize: 13.sp)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }

  Widget _buildField(EvaluationField field) {
    final key = field.key ?? '';
    final label = field.labelEn ?? field.labelAr ?? key;
    final value = _answers[key];

    Widget input;
    switch (field.type) {
      case 'CHOICE':
        input = Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: field.options.map((option) {
            final selected = value == option.code;
            return GestureDetector(
              onTap: () => setState(() => _answers[key] = option.code ?? ''),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: selected ? _primary.withValues(alpha: 0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: selected ? _primary : Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      size: 16.r,
                      color: selected ? _primary : Colors.grey,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      option.labelEn ?? option.labelAr ?? option.code ?? '',
                      style: GoogleFonts.poppins(fontSize: 12.sp, color: selected ? _primary : _textMuted),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
        break;
      case 'TIME':
        input = _pickerBox(
          value ?? '--:--',
          Icons.access_time,
          () async {
            final parts = value?.split(':');
            final initial = parts != null && parts.length == 2
                ? TimeOfDay(hour: int.tryParse(parts[0]) ?? 0, minute: int.tryParse(parts[1]) ?? 0)
                : TimeOfDay.now();
            final picked = await showTimePicker(context: context, initialTime: initial);
            if (picked != null) {
              setState(() => _answers[key] =
                  '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
            }
          },
        );
        break;
      case 'DATE':
        input = _pickerBox(
          value ?? 'yyyy-mm-dd',
          Icons.calendar_today_outlined,
          () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.tryParse(value ?? '') ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) setState(() => _answers[key] = StaffEvaluationProvider.formatDate(picked));
          },
        );
        break;
      case 'NUMBER':
        input = TextFormField(
          key: ValueKey('$_form-$_resetVersion-$key'),
          initialValue: value,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.poppins(fontSize: 13.sp),
          decoration: _inputDecoration(''),
          onChanged: (v) => setState(() => _answers[key] = v),
        );
        break;
      default:
        input = TextFormField(
          key: ValueKey('$_form-$_resetVersion-$key'),
          initialValue: value,
          minLines: 2,
          maxLines: 4,
          style: GoogleFonts.poppins(fontSize: 13.sp),
          decoration: _inputDecoration(''),
          onChanged: (v) => setState(() => _answers[key] = v),
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: field.required),
        input,
      ],
    );
  }

  Widget _pickerBox(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: _boxDecoration(),
        child: Row(
          children: [
            Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 13.sp, color: _textMuted))),
            Icon(icon, size: 18.r, color: _textMuted),
          ],
        ),
      ),
    );
  }
}

Widget _card({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.r)],
    ),
    child: child,
  );
}

Widget _label(String text, {bool required = false}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text.rich(
      TextSpan(
        text: text,
        style: GoogleFonts.poppins(fontSize: 13.sp, color: _textMuted, fontWeight: FontWeight.w500),
        children: [
          if (required) const TextSpan(text: ' *', style: TextStyle(color: Color(0xFFEF4444))),
        ],
      ),
    ),
  );
}

BoxDecoration _boxDecoration() {
  return BoxDecoration(
    color: const Color(0xFFF8FAFC),
    borderRadius: BorderRadius.circular(12.r),
    border: Border.all(color: Colors.grey.shade200),
  );
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.grey),
    filled: true,
    fillColor: const Color(0xFFF8FAFC),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey.shade200)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey.shade200)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: _primary)),
  );
}

DropdownMenuItem<T> _menuItem<T>(T value, String text) {
  return DropdownMenuItem<T>(
    value: value,
    child: Text(text, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 13.sp)),
  );
}

Widget _dropdown<T>({
  required T value,
  required List<DropdownMenuItem<T>> items,
  required ValueChanged<T?> onChanged,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: _boxDecoration(),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.black),
        items: items,
        onChanged: onChanged,
      ),
    ),
  );
}

Widget _dateBox(DateTime? date, {required VoidCallback onTap, VoidCallback? onClear}) {
  final text = date == null
      ? 'dd/mm/yyyy'
      : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 13.sp, color: _textMuted))),
          if (onClear != null)
            GestureDetector(onTap: onClear, child: Icon(Icons.close, size: 18.r, color: Colors.grey))
          else
            Icon(Icons.calendar_today_outlined, size: 18.r, color: _textMuted),
        ],
      ),
    ),
  );
}
