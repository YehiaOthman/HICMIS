import 'package:backtotrack/my_app/my_app.dart';
import 'package:backtotrack/providers/auth_provider.dart';
import 'package:backtotrack/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


