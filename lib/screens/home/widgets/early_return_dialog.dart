import 'package:flutter/material.dart';
import 'package:backtotrack/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/data/models/absence_request.dart';
import 'package:backtotrack/providers/employee_provider.dart';

class EarlyReturnDialog extends StatefulWidget {
  final AbsenceRequest request;

  const EarlyReturnDialog({super.key, required this.request});

  @override
  State<EarlyReturnDialog> createState() => _EarlyReturnDialogState();
}

class _EarlyReturnDialogState extends State<EarlyReturnDialog> {
  late final DateTime _firstDate;
  late final DateTime _lastDate;
  late DateTime _returnDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final start = DateTime.parse(widget.request.startDate!);
    _firstDate = start.add(const Duration(days: 1));
    _lastDate = DateTime.parse(widget.request.endDate!);
    _returnDate = _firstDate;
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  String _formatType(String? type) {
    if (type == null || type.isEmpty) return 'Leave';
    return type
        .split('_')
        .map((w) => w.isEmpty ? w : '${w[0]}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _returnDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2353D0),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _returnDate = picked);
    }
  }

  Future<void> _confirm() async {
    setState(() => _isSubmitting = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final result = await Provider.of<EmployeeProvider>(context, listen: false)
        .requestEarlyReturn(widget.request.id!, _formatDate(_returnDate));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    messenger.showSnackBar(
      SnackBar(
        content: Text(context.tr(result['message'] ?? ''), style: GoogleFonts.poppins(fontSize: 14.sp)),
        backgroundColor: result['success'] ? const Color(0xFF22C55E) : Colors.redAccent,
      ),
    );
    if (result['success']) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF475569));

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr('Early Return Request'),
                    style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                  icon: Icon(Icons.close, size: 22.r, color: const Color(0xFF64748B)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              context.tr('Select the date you intend to return to work. This date must be after the start date of your leave and on or before its end date.'),
              style: labelStyle,
            ),
            SizedBox(height: 12.h),
            Text(context.tr('Absence Type: {0}', [_formatType(widget.request.absenceType)]), style: labelStyle),
            SizedBox(height: 6.h),
            Text(
              context.tr('Start Date - End Date: {0} - {1}', [widget.request.startDate, widget.request.endDate]),
              style: labelStyle,
            ),
            SizedBox(height: 16.h),
            Text(
              context.tr('RETURN DATE'),
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF475569),
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 8.h),
            InkWell(
              onTap: _isSubmitting ? null : _pickDate,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(context.tr(_formatDate(_returnDate)), style: GoogleFonts.poppins(fontSize: 14.sp)),
                    ),
                    Icon(Icons.calendar_today_outlined, size: 18.r, color: const Color(0xFF2353D0)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                  child: Text(context.tr('Cancel'), style: GoogleFonts.poppins(color: const Color(0xFF64748B), fontSize: 14.sp)),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2353D0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          width: 18.r,
                          height: 18.r,
                          child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(context.tr('Confirm'), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
