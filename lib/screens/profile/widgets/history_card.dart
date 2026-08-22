import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const HistoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF64748B), size: 20.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                    Text(subtitle, style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey)),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_up, color: const Color(0xFFCBD5E1), size: 20.r),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: const Divider(color: Color(0xFFF1F5F9)),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}