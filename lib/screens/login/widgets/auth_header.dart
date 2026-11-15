import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color boxColor;

  const AuthHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.boxColor = const Color(0xFF2353D0),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80.r,
          width: 80.r,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Icon(icon, color: Colors.white, size: 40.r),
        ),
        SizedBox(height: 25.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}