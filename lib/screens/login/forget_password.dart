import 'package:backtotrack/data/api_manager.dart';
import 'package:flutter/material.dart';
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
        title: Text('Forgot Password', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const AuthHeader(
              icon: Icons.lock_outline,
              boxColor: Color(0xFFFFB800), // Yellow/Orange color from image
              title: 'Reset Password',
              subtitle: 'Enter the email address linked to your account. We will send you a reset link.',
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
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
                  const SizedBox(height: 25),
                  // Inside forgot_password_screen.dart

                  PrimaryButton(
                    text: 'Send Reset Link',
                    onPressed: () async {
                      var result = await ApiManager.forgotPassword(emailController.text);
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please Enter Your Email',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            backgroundColor: Color(0xFF2353D0),
                          ),
                        );
                        return;
                      }

                      if (result['success']) {
                        Navigator.pushNamed(context, '/check-email',arguments: emailController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['message']), backgroundColor: Color(0xFF2353D0)),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Remembered your password? ", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text("Back to Sign In", style: GoogleFonts.poppins(color: Color(0xFF2353D0), fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}