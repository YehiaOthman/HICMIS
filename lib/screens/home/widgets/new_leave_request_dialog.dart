import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/providers/employee_provider.dart';

class NewLeaveRequestDialog extends StatefulWidget {
  const NewLeaveRequestDialog({super.key});

  @override
  State<NewLeaveRequestDialog> createState() => _NewLeaveRequestDialogState();
}

class _NewLeaveRequestDialogState extends State<NewLeaveRequestDialog> {
  String _absenceType = 'Annual Leave';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _absenceTypes = [
    'Annual Leave',
    'Sick Leave',
    'Time Permission',
    'Maternity Leave',
    'Paternity Leave',
    'Emergency Leave',
    'Unpaid Leave',
    'Bereavement Leave',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  int get _durationDays {
    final diff = _endDate.difference(_startDate).inDays;
    return diff < 0 ? 0 : diff + 1;
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
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
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> _submitRequest() async {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a reason for your leave request.', style: GoogleFonts.poppins(fontSize: 14.sp)),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    final result = await employeeProvider.createAbsenceRequest(
      absenceType: _absenceType,
      startDate: _formatDate(_startDate),
      endDate: _formatDate(_endDate),
      reason: _reasonController.text.trim(),
    );

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Leave request submitted successfully!', style: GoogleFonts.poppins(fontSize: 14.sp)),
            backgroundColor: const Color(0xFF22C55E),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to submit leave request.', style: GoogleFonts.poppins(fontSize: 14.sp)),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: 0.85.sh),
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Leave Request',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(5.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.close, color: const Color(0xFF64748B), size: 20.r),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: const Divider(color: Color(0xFFF1F5F9), thickness: 1),
              ),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('ABSENCE TYPE'),
                      SizedBox(height: 8.h),
                      _buildDropdown(),

                      SizedBox(height: 16.h),

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context, true),
                              child: _buildFieldGroup('START DATE', _formatDate(_startDate)),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context, false),
                              child: _buildFieldGroup('END DATE', _formatDate(_endDate)),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      _buildDurationRow(),

                      SizedBox(height: 20.h),

                      _buildLabel('REASON'),
                      SizedBox(height: 8.h),
                      _buildMultilineField('Please explain the reason for your leave...'),

                      SizedBox(height: 20.h),

                      _buildLabel('ATTACHMENTS'),
                      SizedBox(height: 8.h),
                      _buildUploadArea(),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              Container(
                padding: EdgeInsets.only(top: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildButton(
                        label: 'Cancel',
                        isPrimary: false,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildButton(
                        label: _isSubmitting ? 'Submitting...' : 'Submit Request',
                        isPrimary: true,
                        onTap: _isSubmitting ? () {} : _submitRequest,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF94A3B8),
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildFieldGroup(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(value, style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF1E293B)))),
              Icon(Icons.calendar_today_outlined, size: 16.r, color: const Color(0xFF94A3B8)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationRow() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8.w,
      runSpacing: 4.h,
      children: [
        Text(
          'Requested Duration: ',
          style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF64748B)),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xFF2353D0).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            '$_durationDays ${_durationDays == 1 ? "day" : "days"}',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: const Color(0xFF2353D0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFF2353D0).withOpacity(0.4), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _absenceType,
          icon: Icon(Icons.keyboard_arrow_down, color: const Color(0xFF2353D0), size: 22.r),
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 13.sp),
          isExpanded: true,
          items: _absenceTypes
              .map((String v) => DropdownMenuItem(value: v, child: Text(v, style: GoogleFonts.poppins(fontSize: 13.sp))))
              .toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _absenceType = val);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMultilineField(String hint) {
    return TextFormField(
      controller: _reasonController,
      maxLines: 3,
      style: GoogleFonts.poppins(fontSize: 13.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF94A3B8)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(12.r),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Color(0xFF2353D0)),
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_upload_outlined, size: 30.r, color: const Color(0xFFCBD5E1)),
          SizedBox(height: 6.h),
          Text(
            'DRAG & DROP OR CLICK TO UPLOAD',
            style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8)),
          ),
          Text(
            'SUPPORTING DOCUMENTS (PDF, JPG, PNG)',
            style: GoogleFonts.poppins(fontSize: 9.sp, color: const Color(0xFFCBD5E1)),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 48.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF2353D0) : const Color(0xFFF1F5F9),
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF475569),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
