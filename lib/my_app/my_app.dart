
import 'package:backtotrack/screens/home/home.dart';
import 'package:backtotrack/screens/login/check_email.dart';
import 'package:backtotrack/screens/login/forget_password.dart';
import 'package:backtotrack/screens/login/login_screen.dart';
import 'package:backtotrack/screens/login/sign_up.dart';
import 'package:backtotrack/screens/profile/profile_screen.dart';
import 'package:backtotrack/screens/employees/employees_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'HICIMS',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00C1A3)),
            useMaterial3: true,
          ),
          initialRoute: '/',
            routes: {
              '/': (context) => LoginScreen(),
              '/signup': (context) => SignUpScreen(),
              '/forgot': (context) => ForgotPasswordScreen(),
              '/check-email': (context) =>  CheckEmailScreen(),
              '/home': (context) =>  const HomeScreen(),
              '/profile': (context) =>  const ProfileScreen(),
              '/employees': (context) =>  const EmployeesScreen(),
            },
        );
      },
    );
  }
}