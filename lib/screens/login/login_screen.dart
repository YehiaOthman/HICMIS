import 'package:backtotrack/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'widgets/custom_text_filed.dart';
import 'widgets/custom_password_text_filed.dart';
import 'widgets/auth_header.dart';
import 'widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Sign In',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                const AuthHeader(
                  icon: Icons.person_outline,
                  title: 'Welcome Back',
                  subtitle:
                      'Sign in to access your employee dashboard and account details.',
                  boxColor: Color(0xFF2353D0),
                ),

                SizedBox(height: 35.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 15.r,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CustomTextFiled(
                        label: 'Username',
                        title: 'Enter your username',
                        validator: (val) => null,
                        controller: userController,
                        icon: Icons.person_outline,
                      ),
                      SizedBox(height: 20.h),
                      CustomPasswordTextFiled(
                        label: 'Password',
                        title: 'Enter your password',
                        validator: (val) => null,
                        controller: passController,
                        icon: Icons.lock_outline,
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {
                      //       Navigator.pushNamed(context, '/forgot');
                      //     },
                      //     child: Text(
                      //       'Forgot Password?',
                      //       style: GoogleFonts.poppins(
                      //         color: const Color(0xFF2353D0),
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 13.sp,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 30.h),

                      PrimaryButton(
                        text: 'Sign In',
                        isLoading: authProvider.isLoading,
                        onPressed: () async {
                          if (userController.text.trim().isEmpty ||
                              passController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please fill all fields',
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
                                ),
                                backgroundColor: const Color(0xFF2353D0),
                              ),
                            );
                            return;
                          }

                          final success = await authProvider.login(
                            userController.text.trim(),
                            passController.text.trim(),
                          );

                          if (context.mounted) {
                            if (success) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/home',
                                (route) => false,
                              );
                            } else if (authProvider.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    authProvider.errorMessage!,
                                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
                                  ),
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


                // SizedBox(height: 35.h),

                // Wrap(
                //   alignment: WrapAlignment.center,
                //   crossAxisAlignment: WrapCrossAlignment.center,
                //   children: [
                //     Text(
                //       "Don't have an account? Contact your HR administrator.",
                //       style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13.sp),
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.pushNamed(context, '/signup');
                //       },
                //       child: Text(
                //         "Create Account",
                //         style: GoogleFonts.poppins(
                //           color: const Color(0xFF2353D0),
                //           fontWeight: FontWeight.bold,
                //           fontSize: 13.sp,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 30.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

