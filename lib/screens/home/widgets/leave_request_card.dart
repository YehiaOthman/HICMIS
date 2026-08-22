import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveRequestCard extends StatefulWidget {
  final num? id;
  final String type;
  final String dateRange;
  final String reason;
  final String status;
  final Color statusColor;
  final IconData icon;
  final VoidCallback? onDelete;

  const LeaveRequestCard({
    super.key,
    this.id,
    required this.type,
    required this.dateRange,
    required this.reason,
    required this.status,
    required this.statusColor,
    required this.icon,
    this.onDelete,
  });

  @override
  State<LeaveRequestCard> createState() => _LeaveRequestCardState();
}

class _LeaveRequestCardState extends State<LeaveRequestCard> {
  bool _isExpanded = false;

  String _formatAbsenceType(String apiType) {
    Map<String, String> typeMap = {
      'ANNUAL_LEAVE': 'Annual Leave',
      'SICK_LEAVE': 'Sick Leave',
      'TIME_PERMISSION': 'Time Permission',
      'MATERNITY_LEAVE': 'Maternity Leave',
      'PATERNITY_LEAVE': 'Paternity Leave',
      'EMERGENCY_LEAVE': 'Emergency Leave',
      'UNPAID_LEAVE': 'Unpaid Leave',
      'BEREAVEMENT_LEAVE': 'Bereavement Leave',
    };
    return typeMap[apiType] ?? apiType;
  }

  @override
  Widget build(BuildContext context) {
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
                      Text(_formatAbsenceType(widget.type), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                      Text(widget.dateRange, style: GoogleFonts.poppins(fontSize: 11.sp, color: Colors.grey)),
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
                    widget.status.toUpperCase(),
                    style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.bold, color: widget.statusColor),
                  ),
                ),
                if (widget.onDelete != null && (widget.status.toLowerCase() == 'pending' || widget.status.toLowerCase() == 'draft')) ...[
                  SizedBox(width: 6.w),
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: Icon(Icons.delete_outline, color: const Color(0xFFEF4444), size: 20.r),
                    tooltip: 'Delete Request',
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
                'Reason: ${widget.reason}',
                style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF475569)),
              ),
            ),
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
                    _isExpanded ? ' Hide details' : ' View details',
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
                      'Files are securely stored.',
                      style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF475569)),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              _buildSectionTitle('APPROVAL WORKFLOW STATUS'),
              SizedBox(height: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: widget.statusColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                            widget.status == 'rejected' ? Icons.close : Icons.check,
                            color: widget.statusColor,
                            size: 14.r
                        ),
                      ),
                    ],
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
                              const TextSpan(text: 'HR Manager ', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '(human resources HR)', style: TextStyle(color: Colors.grey[500], fontSize: 11.sp)),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: widget.statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: widget.statusColor.withOpacity(0.2)),
                          ),
                          child: Text(
                            widget.status.toUpperCase(),
                            style: GoogleFonts.poppins(fontSize: 9.sp, fontWeight: FontWeight.bold, color: widget.statusColor),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Jul 16, 2026, 12:35 PM',
                          style: GoogleFonts.poppins(fontSize: 11.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF94A3B8),
        letterSpacing: 1.1,
      ),
    );
  }
}