import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:backtotrack/screens/home/widgets/app_drawer.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      drawer: const AppDrawer(currentRoute: '/employees'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF475569)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: const Color(0xFF2353D0), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.people, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text('Employees', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Employees Management', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('View and manage employee information.', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.people_outline, size: 64, color: Color(0xFFCBD5E1)),
                  const SizedBox(height: 16),
                  Text(
                    'Employees Module',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF475569)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This feature is coming soon. You will be able to manage all employees from here.',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
