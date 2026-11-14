import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/custom_text_filed.dart';
import 'widgets/custom_password_text_filed.dart';
import 'widgets/auth_header.dart';
import 'widgets/primary_button.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController nidController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

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
        title: Text(
          'Create Account',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),

            const AuthHeader(
              icon: Icons.person_add_alt_1_outlined,
              title: 'New Employee Account',
              subtitle: 'Fill in your details to register your HR system account.',
              boxColor: Color(0xFF00C1A3),
            ),

            SizedBox(height: 30.h),

            _buildSectionCard(
              title: "PERSONAL INFORMATION",
              children: [
                CustomTextFiled(
                  label: 'Full Name',
                  title: 'Enter your full name',
                  validator: (v) => null,
                  controller: nameController,
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 20.h),
                CustomTextFiled(
                  label: 'Username',
                  title: 'Choose a username',
                  validator: (v) => null,
                  controller: userController,
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 20.h),
                CustomTextFiled(
                  label: 'National ID (NID)',
                  title: 'Enter your national ID',
                  validator: (v) => null,
                  controller: nidController,
                  icon: Icons.badge_outlined,
                ),
                SizedBox(height: 20.h),
                CustomTextFiled(
                  label: 'Phone Number',
                  title: 'Enter your phone number',
                  validator: (v) => null,
                  controller: phoneController,
                  icon: Icons.phone_outlined,
                ),
              ],
            ),

            SizedBox(height: 20.h),

            _buildSectionCard(
              title: "ACCOUNT CREDENTIALS",
              children: [
                CustomTextFiled(
                  label: 'Email Address',
                  title: 'Enter your email',
                  validator: (v) => null,
                  controller: emailController,
                  icon: Icons.email_outlined,
                ),
                SizedBox(height: 20.h),
                CustomPasswordTextFiled(
                  label: 'Password',
                  title: 'Create a password',
                  validator: (v) => null,
                  controller: passController,
                  icon: Icons.lock_outline,
                ),
                SizedBox(height: 20.h),
                CustomPasswordTextFiled(
                  label: 'Confirm Password',
                  title: 'Repeat your password',
                  validator: (v) => null,
                  controller: confirmPassController,
                  icon: Icons.lock_outline,
                ),
              ],
            ),

            SizedBox(height: 25.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11.sp),
                  children: [
                    const TextSpan(text: "By creating an account you agree to the "),
                    TextSpan(
                      text: "Terms of Use",
                      style: TextStyle(color: const Color(0xFF2353D0), fontWeight: FontWeight.bold, fontSize: 11.sp),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(color: const Color(0xFF2353D0), fontWeight: FontWeight.bold, fontSize: 11.sp),
                    ),
                    const TextSpan(text: " of this HR system."),
                  ],
                ),
              ),
            ),

            SizedBox(height: 25.h),

            PrimaryButton(
              text: 'Create Account',
              onPressed: () {},
            ),

            SizedBox(height: 25.h),

            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Already have an account? ",
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13.sp)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text("Sign In",
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF2353D0),
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp)),
                ),
              ],
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF94A3B8),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          ...children,
        ],
      ),
    );
  }
}