import 'package:backtotrack/providers/auth_provider.dart';
import 'package:flutter/material.dart';
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
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF2353D0),
                  ),
                ),
              );
            });
          }

          if (authProvider.status == AuthStatus.error && authProvider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    authProvider.errorMessage!,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  backgroundColor: Color(0xFF2353D0),
                  behavior: SnackBarBehavior.fixed,
                ),
              );
              authProvider.clearError();
            });
          }

          if (authProvider.isAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const AuthHeader(
                  icon: Icons.person_outline,
                  title: 'Welcome Back',
                  subtitle:
                      'Sign in to access your employee dashboard and account details.',
                  boxColor: Color(0xFF00C1A3),
                ),

                const SizedBox(height: 35),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
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
                      const SizedBox(height: 20),
                      CustomPasswordTextFiled(
                        label: 'Password',
                        title: 'Enter your password',
                        validator: (val) => null,
                        controller: passController,
                        icon: Icons.lock_outline,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot');
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF2353D0),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      PrimaryButton(
                        text: 'Sign In',
                        onPressed: () async {
                          if (userController.text.isEmpty ||
                              passController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please fill all fields',
                                  style: GoogleFonts.poppins(color: Colors.white),
                                ),
                                backgroundColor: Color(0xFF2353D0),
                              ),
                            );
                            return;
                          }

                          await authProvider.login(
                            userController.text,
                            passController.text,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        "Create Account",
                        style: GoogleFonts.poppins(
                          color: Color(0xFF2353D0),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
