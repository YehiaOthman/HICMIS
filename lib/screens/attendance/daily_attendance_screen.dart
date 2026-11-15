import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/screens/home/widgets/app_drawer.dart';
import 'package:backtotrack/providers/daily_attendance_provider.dart';
import 'package:backtotrack/data/models/daily_attendance_report.dart';

class DailyAttendanceScreen extends StatefulWidget {
  const DailyAttendanceScreen({super.key});

  @override
  State<DailyAttendanceScreen> createState() => _DailyAttendanceScreenState();
}

class _DailyAttendanceScreenState extends State<DailyAttendanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DailyAttendanceProvider>(context, listen: false);
      provider.fetchDepartments();
      provider.fetchReport();
    });
  }

  Future<void> _pickDate() async {
    final provider = Provider.of<DailyAttendanceProvider>(context, listen: false);
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      provider.setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      drawer: const AppDrawer(currentRoute: '/daily-attendance'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: const Color(0xFF475569), size: 22.r),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(color: const Color(0xFF2353D0), borderRadius: BorderRadius.circular(8.r)),
              child: Icon(Icons.home_filled, color: Colors.white, size: 20.r),
            ),
            SizedBox(width: 10.w),
            Text('HICMIS', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
          ],
        ),
      ),
      body: Consumer<DailyAttendanceProvider>(
        builder: (context, provider, child) {
          final report = provider.report;
          final rows = report?.rows ?? [];

          return RefreshIndicator(
            onRefresh: () => provider.fetchReport(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Daily Attendance', style: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                            Text(
                              report?.dayOfWeek != null
                                  ? '${_capitalize(report!.dayOfWeek!)}${report.nonWorkingDay == true ? ' · Non-working day' : ''}'
                                  : 'Daily workspace presence report.',
                              style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          height: 44.r,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2353D0),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, color: Colors.white, size: 18.r),
                              SizedBox(width: 6.w),
                              Text(
                                _formatDisplayDate(provider.selectedDate),
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  if (report?.summary != null) _buildSummary(report!.summary!),

                  SizedBox(height: 20.h),

                  _buildFilters(provider),

                  SizedBox(height: 20.h),

                  if (!provider.isLoading && report != null)
                    Text(
                      '${rows.length} employees',
                      style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13.sp),
                    ),
                  SizedBox(height: 15.h),

                  if (provider.isLoading)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: const Center(
                        child: CircularProgressIndicator(color: Color(0xFF2353D0)),
                      ),
                    )
                  else if (rows.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(30.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.event_note_outlined, size: 48.r, color: const Color(0xFFCBD5E1)),
                          SizedBox(height: 10.h),
                          Text(
                            'No Records',
                            style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xFF475569)),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            provider.error ?? 'No employees match this day and filters.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    ...rows.map(_buildRowCard),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummary(DailyAttendanceSummary summary) {
    final rate = (summary.attendanceRatePercent ?? 0).toDouble();
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _summaryCard(Icons.people, const Color(0xFF2353D0), '${summary.totalEmployees ?? 0}', 'TOTAL STAFF')),
            SizedBox(width: 12.w),
            Expanded(
              child: _summaryCard(
                Icons.trending_up,
                const Color(0xFF2353D0),
                '${rate.toStringAsFixed(2)}%',
                'PRESENCE RATE',
                progress: (rate / 100).clamp(0.0, 1.0),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _summaryCard(Icons.check_circle, const Color(0xFF10B981), '${summary.completeDay ?? 0}', 'PRESENT')),
            SizedBox(width: 12.w),
            Expanded(child: _summaryCard(Icons.access_time, const Color(0xFFF59E0B), '${summary.late ?? 0}', 'LATE')),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _summaryCard(Icons.calendar_month, const Color(0xFF8B5CF6), '${summary.onLeave ?? 0}', 'ON LEAVE')),
            SizedBox(width: 12.w),
            Expanded(child: _summaryCard(Icons.cancel, const Color(0xFFEF4444), '${summary.absent ?? 0}', 'ABSENT')),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard(IconData icon, Color color, String value, String label, {double? progress}) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10.r)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10.r)),
                child: Icon(icon, color: color, size: 18.r),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(value, style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(label, style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w600, color: const Color(0xFF94A3B8))),
          if (progress != null) ...[
            SizedBox(height: 6.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5.h,
                backgroundColor: const Color(0xFFF1F5F9),
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilters(DailyAttendanceProvider provider) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Department', style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF475569), fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<num?>(
                value: provider.departmentId,
                isExpanded: true,
                style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.black),
                items: [
                  DropdownMenuItem<num?>(value: null, child: Text('All Departments', style: GoogleFonts.poppins(fontSize: 13.sp))),
                  ...provider.departments.map((d) => DropdownMenuItem<num?>(
                        value: d.id,
                        child: Text(d.nameEn ?? d.code ?? '', style: GoogleFonts.poppins(fontSize: 13.sp)),
                      )),
                ],
                onChanged: (v) => provider.setDepartment(v),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Text('Status', style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF475569), fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: DailyAttendanceProvider.allStatuses.map((status) {
              final selected = provider.selectedStatuses.contains(status);
              final color = _statusColor(status);
              return GestureDetector(
                onTap: () => provider.toggleStatus(status),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: selected ? color : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _statusLabel(status),
                    style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w600, color: selected ? Colors.white : color),
                  ),
                ),
              );
            }).toList(),
          ),
          if (provider.departmentId != null || provider.selectedStatuses.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: provider.clearFilters,
                icon: Icon(Icons.refresh, size: 18.r),
                label: Text('Clear', style: TextStyle(fontSize: 13.sp)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00C1A3),
                  side: const BorderSide(color: Color(0xFF00C1A3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRowCard(DailyAttendanceRow row) {
    final name = row.employeeName ?? 'Unknown';
    final status = row.status ?? '';
    final color = _statusColor(status);
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10.r)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: _getAvatarColor(name),
                child: Text(
                  _initials(name),
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
                    Text(row.empCode ?? '', style: GoogleFonts.poppins(fontSize: 11.sp, color: Colors.grey)),
                    if (row.department != null)
                      Text(row.department!, style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF475569))),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              _statusLabel(status),
              style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w600, color: color),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(child: _buildInfo('First Check-In', _formatTime(row.checkIn))),
              Expanded(child: _buildInfo('Last Check-Out', _formatTime(row.checkOut))),
              Expanded(child: _buildInfo('Worked Hours', row.payableHours?.toStringAsFixed(2) ?? '-')),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(child: _buildInfo('Late Check-In (mins)', row.lateMinutes?.toString() ?? '-')),
              Expanded(child: _buildInfo('Early Departure (mins)', row.earlyLeaveMinutes?.toString() ?? '-')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 10.sp, color: const Color(0xFF94A3B8))),
        SizedBox(height: 2.h),
        Text(value, style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF475569))),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'COMPLETE_DAY':
        return const Color(0xFF10B981);
      case 'IN_PROGRESS':
        return const Color(0xFF2353D0);
      case 'VACATION':
        return const Color(0xFF8B5CF6);
      case 'HALF_DAY_DEDUCTION':
        return const Color(0xFFF59E0B);
      case 'FULL_DAY_DEDUCTION':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  String _statusLabel(String status) => status.replaceAll('_', ' ');

  String _capitalize(String value) =>
      value.isEmpty ? value : value[0].toUpperCase() + value.substring(1).toLowerCase();

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  String _formatTime(String? value) {
    if (value == null || value.isEmpty) return '--:--';
    final dt = DateTime.tryParse(value);
    if (dt == null) return value;
    final local = dt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatDisplayDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  Color _getAvatarColor(String? name) {
    if (name == null || name.isEmpty) return const Color(0xFF94A3B8);
    final colors = [
      const Color(0xFF2353D0),
      const Color(0xFF00C1A3),
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
    ];
    final index = name.hashCode % colors.length;
    return colors[index.abs()];
  }
}
