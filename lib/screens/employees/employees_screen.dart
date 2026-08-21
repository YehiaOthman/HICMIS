import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/screens/home/widgets/app_drawer.dart';
import 'package:backtotrack/providers/employee_provider.dart';
import 'widgets/employees_card.dart';
import 'employee_detail_screen.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  bool _showFilters = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchEmployees();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
      if (employeeProvider.hasMoreEmployees && !employeeProvider.isEmployeesLoading) {
        employeeProvider.fetchEmployees(search: _searchController.text, reset: false);
      }
    }
  }

  void _fetchEmployees() {
    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    employeeProvider.fetchEmployees(search: _searchController.text);
  }

  void _onSearchChanged(String value) {
    setState(() {});
    // Debounce search for API call
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == value) {
        _fetchEmployees();
      }
    });
  }

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
        controller: _scrollController,
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
                      controller: _searchController,
                      onChanged: _onSearchChanged,
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
            Consumer<EmployeeProvider>(
              builder: (context, employeeProvider, child) {
                final allEmployees = employeeProvider.employeesList;
                final isLoading = employeeProvider.isEmployeesLoading;
                final total = employeeProvider.totalEmployees;
                final searchQuery = _searchController.text.toLowerCase().trim();

                // Apply client-side filtering
                final filteredEmployees = searchQuery.isEmpty
                    ? allEmployees
                    : allEmployees.where((employee) {
                        final name = (employee.name ?? '').toLowerCase();
                        final code = (employee.empCode ?? '').toLowerCase();
                        final department = (employee.departmentName ?? '').toLowerCase();
                        return name.contains(searchQuery) ||
                               code.contains(searchQuery) ||
                               department.contains(searchQuery);
                      }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      searchQuery.isEmpty
                          ? (total != null ? '$total employees found' : 'Loading...')
                          : '${filteredEmployees.length} employees found',
                      style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 15),

                    if (isLoading && allEmployees.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(color: Color(0xFF2353D0)),
                        ),
                      )
                    else if (filteredEmployees.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.people_outline, size: 48, color: Color(0xFFCBD5E1)),
                            const SizedBox(height: 10),
                            Text(
                              'No Employees Found',
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF475569)),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              searchQuery.isEmpty
                                  ? 'No employees available.'
                                  : 'Try adjusting your search or filters.',
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: [
                          ...filteredEmployees.map((employee) => EmployeeCard(
                            name: employee.name ?? 'Unknown',
                            id: employee.id?.toString() ?? '',
                            code: employee.empCode ?? '',
                            department: employee.departmentName ?? 'Unknown',
                            hireDate: employee.hireDate ?? '',
                            avatarColor: _getAvatarColor(employee.name),
                            onViewPressed: () {
                              if (employee.id != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmployeeDetailScreen(
                                      employeeId: employee.id!,
                                      employeeName: employee.name ?? 'Employee',
                                    ),
                                  ),
                                );
                              }
                            },
                          )),
                          if (isLoading && allEmployees.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: CircularProgressIndicator(color: Color(0xFF2353D0)),
                              ),
                            ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(String? name) {
    if (name == null || name.isEmpty) return const Color(0xFF94A3B8);
    final colors = [
      const Color(0xFF2353D0),
      const Color(0xFF00C1A3),
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
    ];
    final index = name.hashCode % colors.length;
    return colors[index.abs()];
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
