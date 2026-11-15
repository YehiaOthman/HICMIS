import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String id;
  final String code;
  final String department;
  final String hireDate;
  final Color avatarColor;
  final VoidCallback? onViewPressed;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.id,
    required this.code,
    required this.department,
    required this.hireDate,
    required this.avatarColor,
    this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          )
        ],
      ),
      child: Row(
        children: [
          // Avatar with Initials
          CircleAvatar(
            radius: 25.r,
            backgroundColor: avatarColor,
            child: Text(
              _getInitials(name),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
          ),
          SizedBox(width: 12.w),
          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Badge ID
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '#$id',
                        style: GoogleFonts.poppins(fontSize: 10.sp, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                _buildSmallInfo(Icons.badge_outlined, 'Code: $code'),
                SizedBox(height: 4.h),
                _buildSmallInfo(Icons.business_outlined, department),
                SizedBox(height: 4.h),
                _buildSmallInfo(null, 'Hired: $hireDate'),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // View Button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2353D0).withOpacity(0.05),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: IconButton(
              icon: Icon(Icons.visibility_outlined, color: const Color(0xFF2353D0), size: 20.r),
              onPressed: onViewPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfo(IconData? icon, String text) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14.r, color: const Color(0xFFCBD5E1)),
          SizedBox(width: 5.w),
        ],
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF94A3B8)),
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    
    String initials = '';
    for (var part in parts) {
      if (part.isNotEmpty) {
        initials += part[0];
      }
      if (initials.length >= 2) break;
    }
    
    return initials.isEmpty ? '?' : initials.toUpperCase();
  }
}