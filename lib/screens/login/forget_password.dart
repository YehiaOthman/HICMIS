import 'package:backtotrack/data/api_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/custom_text_filed.dart';
import 'widgets/auth_header.dart';
import 'widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('Forgot Password', style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            const AuthHeader(
              icon: Icons.lock_outline,
              boxColor: Color(0xFF2353D0),
              title: 'Reset Password',
              subtitle: 'Enter the email address linked to your account. We will send you a reset link.',
            ),
            SizedBox(height: 40.h),
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Column(
                children: [
                  CustomTextFiled(
                    label: 'Email Address',
                    title: 'Enter your email',
                    validator: (v) => null,
                    controller: emailController,
                    icon: Icons.email_outlined,
                  ),
                  SizedBox(height: 25.h),

                  PrimaryButton(
                    text: 'Send Reset Link',
                    onPressed: () async {
                      if (emailController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please Enter Your Email',
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
                            ),
                            backgroundColor: const Color(0xFF2353D0),
                          ),
                        );
                        return;
                      }

                      var result = await ApiManager.forgotPassword(emailController.text.trim());
                      if (context.mounted) {
                        if (result['success']) {
                          Navigator.pushNamed(context, '/check-email', arguments: emailController.text.trim());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result['message'] ?? 'Error occurred', style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp)),
                              backgroundColor: const Color(0xFF2353D0),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Remembered your password? ", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13.sp)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text("Back to Sign In", style: GoogleFonts.poppins(color: const Color(0xFF2353D0), fontWeight: FontWeight.bold, fontSize: 13.sp)),
                ),
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
