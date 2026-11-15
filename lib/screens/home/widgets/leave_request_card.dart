import 'package:flutter/material.dart';
import 'package:backtotrack/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:backtotrack/data/models/absence_request.dart';

class LeaveRequestCard extends StatefulWidget {
  final num? id;
  final String type;
  final String dateRange;
  final String reason;
  final String status;
  final Color statusColor;
  final IconData icon;
  final String? breakFromDate;
  final List<ApprovalStep> approvalSteps;
  final VoidCallback? onDelete;
  final Future<void> Function()? onSubmit;
  final VoidCallback? onEarlyReturn;
  final String? employeeName;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const LeaveRequestCard({
    super.key,
    this.id,
    required this.type,
    required this.dateRange,
    required this.reason,
    required this.status,
    required this.statusColor,
    required this.icon,
    this.breakFromDate,
    this.approvalSteps = const [],
    this.onDelete,
    this.onSubmit,
    this.onEarlyReturn,
    this.employeeName,
    this.onApprove,
    this.onReject,
  });

  @override
  State<LeaveRequestCard> createState() => _LeaveRequestCardState();
}

class _LeaveRequestCardState extends State<LeaveRequestCard> {
  bool _isExpanded = false;
  bool _isSubmitting = false;

  String _formatAbsenceType(String apiType) {
    Map<String, String> typeMap = {
      'ANNUAL_LEAVE': 'Annual Leave',
      'SICK_LEAVE': 'Sick Leave',
      'TIME_PERMISSION': 'Time Permission',
      'MISSION': 'Mission',
      'MATERNITY_LEAVE': 'Maternity Leave',
      'PATERNITY_LEAVE': 'Paternity Leave',
      'EMERGENCY_LEAVE': 'Emergency Leave',
      'UNPAID_LEAVE': 'Unpaid Leave',
      'BEREAVEMENT_LEAVE': 'Bereavement Leave',
    };
    return typeMap[apiType] ?? apiType;
  }

  String _formatRole(String? role) {
    switch (role) {
      case 'HR':
        return 'HR Manager';
      case 'MANAGER':
        return 'Manager';
      case 'SUPER_ADMIN':
        return 'Super Admin';
      case 'ADMIN':
        return 'Admin';
      case 'FINANCE':
        return 'Finance';
      case 'ACADEMIC_OBSERVER':
        return 'Academic Observer';
      case 'EMPLOYEE':
        return 'Employee';
      default:
        return role ?? 'Approver';
    }
  }

  String _formatDateTime(String? value) {
    final dt = DateTime.tryParse(value ?? '')?.toLocal();
    if (dt == null) return '';
    final months = context.isArabic
        ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final period = dt.hour < 12 ? context.tr('AM') : context.tr('PM');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}, '
        '${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';
  }

  Color _stepColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'APPROVED':
        return const Color(0xFF22C55E);
      case 'REJECTED':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    await widget.onSubmit!();
    if (mounted) setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status.toLowerCase();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border(
          left: BorderSide(color: widget.statusColor, width: 4.w),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2353D0).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(widget.icon, color: const Color(0xFF2353D0), size: 20.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.tr(_formatAbsenceType(widget.type)), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                      if (widget.employeeName != null && widget.employeeName!.isNotEmpty)
                        Text(context.tr(widget.employeeName!), style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF2353D0), fontWeight: FontWeight.w600)),
                      Text(context.tr(widget.dateRange), style: GoogleFonts.poppins(fontSize: 11.sp, color: Colors.grey)),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: widget.statusColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    context.tr(widget.status.replaceAll('_', ' ').toUpperCase()),
                    style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.bold, color: widget.statusColor),
                  ),
                ),
                if (widget.onDelete != null && (status == 'pending' || status == 'draft')) ...[
                  SizedBox(width: 6.w),
                  IconButton(
                    onPressed: _isSubmitting ? null : widget.onDelete,
                    icon: Icon(Icons.delete_outline, color: const Color(0xFFEF4444), size: 20.r),
                    tooltip: context.tr('Delete Request'),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),

            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                context.tr(widget.breakFromDate != null
                    ? context.tr('Early return on: {0}', [widget.breakFromDate])
                    : context.tr('Reason: {0}', [widget.reason])),
                style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF475569)),
              ),
            ),

            if ((widget.onSubmit != null && status == 'draft') ||
                (widget.onEarlyReturn != null && status == 'approved')) ...[
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: status == 'draft'
                    ? ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        icon: _isSubmitting
                            ? SizedBox(
                                width: 14.r,
                                height: 14.r,
                                child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Icon(Icons.send_outlined, size: 16.r),
                        label: Text(context.tr('Submit'), style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2353D0),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: widget.onEarlyReturn,
                        icon: Icon(Icons.directions_walk, size: 16.r),
                        label: Text(context.tr('Request Early Return'), style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                        ),
                      ),
              ),
            ],

            if (widget.onApprove != null || widget.onReject != null) ...[
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.onReject != null)
                    OutlinedButton.icon(
                      onPressed: widget.onReject,
                      icon: Icon(Icons.close, size: 16.r),
                      label: Text(context.tr('Reject'), style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        side: const BorderSide(color: Color(0xFFEF4444)),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                    ),
                  if (widget.onApprove != null && widget.onReject != null) SizedBox(width: 8.w),
                  if (widget.onApprove != null)
                    ElevatedButton.icon(
                      onPressed: widget.onApprove,
                      icon: Icon(Icons.check, size: 16.r),
                      label: Text(context.tr('Approve'), style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                    ),
                ],
              ),
            ],

            SizedBox(height: 10.h),

            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                children: [
                  Icon(
                      _isExpanded ? Icons.close : Icons.add,
                      size: 14.r,
                      color: const Color(0xFF2353D0)
                  ),
                  Text(
                    context.tr(_isExpanded ? context.tr(' Hide details') : context.tr(' View details')),
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: const Color(0xFF2353D0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            if (_isExpanded) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: const Divider(color: Color(0xFFF1F5F9)),
              ),

              _buildSectionTitle('ATTACHMENTS'),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.attach_file, size: 16.r, color: Colors.grey),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      context.tr('Files are securely stored.'),
                      style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF475569)),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              _buildSectionTitle('APPROVAL WORKFLOW STATUS'),
              SizedBox(height: 12.h),
              if (widget.approvalSteps.isEmpty)
                Text(
                  context.tr(status == 'draft' ? context.tr('Not submitted yet.') : context.tr('No approval steps yet.')),
                  style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey),
                )
              else
                ...widget.approvalSteps.map(_buildStep),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildStep(ApprovalStep step) {
    final color = _stepColor(step.status);
    final decidedAt = _formatDateTime(step.decidedAt);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step.status?.toUpperCase() == 'REJECTED'
                  ? Icons.close
                  : step.status?.toUpperCase() == 'APPROVED'
                      ? Icons.check
                      : Icons.hourglass_empty,
              color: color,
              size: 14.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.black),
                    children: [
                      TextSpan(text: '${_formatRole(step.approverRole)} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (step.approverName != null && step.approverName!.isNotEmpty)
                        TextSpan(text: '(${step.approverName})', style: TextStyle(color: Colors.grey[500], fontSize: 11.sp)),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Text(
                    context.tr((step.status ?? 'PENDING').toUpperCase()),
                    style: GoogleFonts.poppins(fontSize: 9.sp, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
                if (decidedAt.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    context.tr(decidedAt),
                    style: GoogleFonts.poppins(fontSize: 11.sp, color: Colors.grey),
                  ),
                ],
                if (step.comment != null && step.comment!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    context.tr(step.comment!),
                    style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF475569)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      context.tr(title),
      style: GoogleFonts.poppins(
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF94A3B8),
        letterSpacing: 1.1,
      ),
    );
  }
}
