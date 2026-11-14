import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        iconTheme: IconThemeData(color: const Color(0xFF475569), size: 22.r),
        title: Row(
      children: [
      Container(
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(color: const Color(0xFF2353D0), borderRadius: BorderRadius.circular(8.r)),
      child: Icon(Icons.home_filled, color: Colors.white, size: 20.r),
    ),
    SizedBox(width: 10.w),
    Text('HICMIS', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
    ],
    ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Employee Registry', style: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                      Text('Search, view full details and\n onboard personnel.',
                          style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey)),
                    ],
                  ),
                ),
                // ElevatedButton.icon(
                //   onPressed: () {},
                //   icon: Icon(Icons.add, size: 18.r),
                //   label: Text('Onboard', style: TextStyle(fontSize: 13.sp)),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color(0xFF2353D0),
                //     foregroundColor: Colors.white,
                //     padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                //   ),
                // ),
              ],
            ),

            SizedBox(height: 25.h),

            // Search Bar Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10.r)],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      style: GoogleFonts.poppins(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: 'Search by name...',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14.sp),
                        prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.r),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                  child: Container(
                    height: 50.r,
                    width: 50.r,
                    decoration: BoxDecoration(
                      color: _showFilters ? const Color(0xFF2353D0) : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Icon(Icons.tune, color: _showFilters ? Colors.white : Colors.grey.shade600, size: 22.r),
                  ),
                ),
              ],
            ),

            SizedBox(height: 15.h),

            // Filter Section Card
            if (_showFilters)
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FILTER EMPLOYEES',
                        style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8), letterSpacing: 1.1)),
                    SizedBox(height: 20.h),
                    _buildFilterField('Employee Code', 'e.g. EMP-0042', Icons.badge_outlined),
                    SizedBox(height: 15.h),
                    _buildFilterField('National ID (NID)', '14-digit NID', Icons.badge_outlined),
                    SizedBox(height: 15.h),
                    _buildLabel('Department'),
                    SizedBox(height: 8.h),
                    _buildDropdownField(),
                    SizedBox(height: 25.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.refresh, size: 18.r),
                            label: Text('Clear', style: TextStyle(fontSize: 13.sp)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF00C1A3),
                              side: const BorderSide(color: Color(0xFF00C1A3)),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.filter_alt_outlined, size: 18.r),
                            label: Text('Apply Filters', style: TextStyle(fontSize: 13.sp)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2353D0),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            SizedBox(height: 25.h),
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
                      style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13.sp),
                    ),
                    SizedBox(height: 15.h),

                    if (isLoading && allEmployees.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: const Center(
                          child: CircularProgressIndicator(color: Color(0xFF2353D0)),
                        ),
                      )
                    else if (filteredEmployees.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(30.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.people_outline, size: 48.r, color: const Color(0xFFCBD5E1)),
                            SizedBox(height: 10.h),
                            Text(
                              'No Employees Found',
                              style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xFF475569)),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              searchQuery.isEmpty
                                  ? 'No employees available.'
                                  : 'Try adjusting your search or filters.',
                              style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey),
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
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: const Center(
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
    return Text(text, style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF475569), fontWeight: FontWeight.w500));
  }

  Widget _buildFilterField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        SizedBox(height: 8.h),
        TextField(
          style: GoogleFonts.poppins(fontSize: 13.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.grey),
            prefixIcon: Icon(icon, size: 18.r, color: const Color(0xFFCBD5E1)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: EdgeInsets.all(12.r),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'All Departments',
          isExpanded: true,
          style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.black),
          items: ['All Departments', 'IT', 'HR'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.poppins(fontSize: 13.sp)))).toList(),
          onChanged: (v) {},
        ),
      ),
    );
  }
}

