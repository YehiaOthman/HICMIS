import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:backtotrack/screens/home/widgets/app_drawer.dart';
import 'widgets/employees_card.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      drawer: const AppDrawer(currentRoute: '/employees'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF475569)),
        title: Text(
          'Employee Registry',
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Employee Registry', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('Search, view full details and\n onboard personnel.',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Onboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2353D0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Search Bar Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by name...',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: _showFilters ? const Color(0xFF2353D0) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Icon(Icons.tune, color: _showFilters ? Colors.white : Colors.grey.shade600),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Filter Section Card
            if (_showFilters)
              Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FILTER EMPLOYEES',
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8), letterSpacing: 1.1)),
                  const SizedBox(height: 20),
                  _buildFilterField('Employee Code', 'e.g. EMP-0042', Icons.badge_outlined),
                  const SizedBox(height: 15),
                  _buildFilterField('National ID (NID)', '14-digit NID', Icons.badge_outlined),
                  const SizedBox(height: 15),
                  _buildLabel('Department'),
                  const SizedBox(height: 8),
                  _buildDropdownField(),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Clear'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF00C1A3),
                            side: const BorderSide(color: Color(0xFF00C1A3)),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_alt_outlined, size: 18),
                          label: const Text('Apply Filters'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2353D0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            Text('6 employees found', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 15),

            // Employee List
             EmployeeCard(
              name: 'Adham Ghobashy',
              id: '1',
              code: '0',
              department: 'Human Resources',
              hireDate: '2026-06-26',
              avatarColor: Color(0xFF00C1A3),
            ),
             EmployeeCard(
              name: 'ADMIN',
              id: '4',
              code: '100',
              department: 'Management',
              hireDate: '2026-01-01',
              avatarColor: Color(0xFFEF4444),
            ),
          ],
        ),
      ),
    );
  }

  // Helper UI methods
  Widget _buildLabel(String text) {
    return Text(text, style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF475569), fontWeight: FontWeight.w500));
  }

  Widget _buildFilterField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18, color: const Color(0xFFCBD5E1)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'All Departments',
          isExpanded: true,
          items: ['All Departments', 'IT', 'HR'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {},
        ),
      ),
    );
  }
}
