import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/providers/employee_provider.dart';
import 'package:backtotrack/providers/auth_provider.dart';
import 'package:backtotrack/screens/home/widgets/app_drawer.dart';
import 'widgets/profile_info_tile.dart';
import 'widgets/history_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeProvider = Provider.of<EmployeeProvider>(
        context,
        listen: false,
      );
      employeeProvider.fetchEmployeeProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    double columnWidth = (1.sw - 90.w) / 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      drawer: const AppDrawer(currentRoute: '/profile'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: const Color(0xFF475569), size: 22.r),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black, size: 22.r),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'My Account Profile',
          style: GoogleFonts.poppins(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<EmployeeProvider>(
                context,
                listen: false,
              ).fetchEmployeeProfile();
            },
            icon: Icon(Icons.refresh, color: Colors.black, size: 22.r),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none, size: 22.r),
          ),
        ],
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, employeeProvider, child) {
          if (employeeProvider.isLoading &&
              employeeProvider.employeeData == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2353D0)),
            );
          }

          if (employeeProvider.errorMessage != null &&
              employeeProvider.employeeData == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.r,
                      color: Colors.redAccent,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      employeeProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton.icon(
                      onPressed: () => employeeProvider.fetchEmployeeProfile(),
                      icon: Icon(Icons.refresh, size: 18.r),
                      label: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2353D0),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = employeeProvider.employeeData;
          final authProvider = Provider.of<AuthProvider>(
            context,
            listen: false,
          );

          return RefreshIndicator(
            onRefresh: () => employeeProvider.fetchEmployeeProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 35.r,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person_outline,
                                size: 35.r,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 10.w,
                                    runSpacing: 4.h,
                                    children: [
                                      Text(
                                        data?.name ?? 'Employee',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      _buildStatusChip(
                                        'ACTIVE ACCOUNT',
                                        Colors.green,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  _buildStatusChip(
                                    data?.position ?? 'EMPLOYEE',
                                    const Color(0xFF2353D0),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    authProvider.username != null
                                        ? '${authProvider.username}@xtra.com'
                                        : 'employee@xtra.com',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10.r,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PERSONAL INFORMATION',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2353D0),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 25.h),
                              Wrap(
                                runSpacing: 20.h,
                                spacing: 10.w,
                                children: [
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Username ID',
                                      value:
                                          authProvider.username ??
                                          (data?.empCode != null
                                              ? '${data!.empCode}'
                                              : 'N/A'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Employee Code',
                                      value: data?.empCode?.toString() ?? 'N/A',
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'National ID (NID)',
                                      value: data?.nid ?? 'N/A',
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Phone Number',
                                      value: data?.phone ?? 'N/A',
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Assigned Department',
                                      value: data?.departmentName ?? 'N/A',
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Direct Manager',
                                      value:
                                          data?.directManagerName?.toString() ??
                                          'N/A',
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Employment Onboarding',
                                      value: data?.hireDate ?? 'N/A',
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Title',
                                      value: data?.title ?? 'N/A',
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Job Position',
                                      value: data?.position ?? 'N/A',
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Marital Status',
                                      value: data?.maritalStatus ?? 'N/A',
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Place of Birth',
                                      value: data?.birthLocation ?? 'N/A',
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Normal Check-In',
                                      value: data?.normalCheckInTime ?? 'N/A',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              ProfileInfoTile(
                                label: 'Job Description',
                                value: data?.currentJobDescription ?? 'N/A',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),

                        if (employeeProvider.educationHistory.isEmpty)
                          HistoryCard(
                            icon: Icons.school_outlined,
                            title: 'Education History',
                            subtitle:
                                'Manage degrees, institutions, and years of study.',
                            child: Text(
                              'No education history records found.',
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          )
                        else
                          ...employeeProvider.educationHistory.map(
                            (edu) => HistoryCard(
                              icon: Icons.school_outlined,
                              title: 'Education History',
                              subtitle: 'Degree & academic background.',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${edu.degree ?? 'Degree'}${edu.major != null && edu.major!.isNotEmpty ? ' - ${edu.major}' : ''}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (edu.institution != null &&
                                      edu.institution!.isNotEmpty)
                                    Text(
                                      edu.institution!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    '${edu.startDate ?? ''} ${(edu.endDate != null && edu.endDate!.isNotEmpty) ? '- ${edu.endDate}' : ''}'
                                        .trim(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.sp,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        if (employeeProvider.positionHistory.isEmpty)
                          HistoryCard(
                            icon: Icons.work_outline,
                            title: 'Position History',
                            subtitle:
                                'Manage positions, departments, and tenure dates.',
                            child: Text(
                              'No position history records found.',
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          )
                        else
                          ...employeeProvider.positionHistory.map(
                            (pos) => HistoryCard(
                              icon: Icons.work_outline,
                              title: 'Position History',
                              subtitle: 'Role & department progression.',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pos.title ?? 'Position',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (pos.departmentName != null &&
                                      pos.departmentName!.isNotEmpty)
                                    Text(
                                      pos.departmentName!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    '${pos.startDate ?? ''} ${(pos.endDate != null && pos.endDate!.isNotEmpty) ? '- ${pos.endDate}' : '- Present'}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.sp,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.r),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

