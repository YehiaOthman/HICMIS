
import 'package:backtotrack/screens/login/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Check Your Email', style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 100.r,
                    width: 100.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2353D0).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2353D0).withOpacity(0.2), width: 2.r),
                    ),
                    child: Icon(Icons.email_outlined, color: const Color(0xFF2353D0), size: 40.r),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: const BoxDecoration(color: Color(0xFF2353D0), shape: BoxShape.circle),
                    child: Icon(Icons.check, color: Colors.white, size: 14.r),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Text('Link Sent!', style: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Text(
              'A password reset link has been sent to your email address. Please check your inbox and follow the instructions.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.grey[500]),
            ),
            SizedBox(height: 40.h),
            Container(
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(color: const Color(0xFFFFB800).withOpacity(0.1), borderRadius: BorderRadius.circular(10.r)),
                    child: Icon(Icons.email_outlined, color: const Color(0xFFFFB800), size: 20.r),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SENT TO', style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                        Text(
                          email,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
                        ),
                        Text('Link expires in 30 minutes', style: GoogleFonts.poppins(fontSize: 11.sp, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            PrimaryButton(
              text: 'Back to Sign In',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
            ),
            SizedBox(height: 25.h),
            TextButton(
              onPressed: () {},
              child: Text('Resend Email', style: GoogleFonts.poppins(color: const Color(0xFF2353D0), fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}