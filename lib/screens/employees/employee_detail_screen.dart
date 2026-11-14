import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/providers/employee_provider.dart';
import 'package:backtotrack/screens/profile/widgets/profile_info_tile.dart';
import 'package:backtotrack/screens/profile/widgets/history_card.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final num employeeId;
  final String employeeName;

  const EmployeeDetailScreen({
    super.key,
    required this.employeeId,
    required this.employeeName,
  });

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeProvider = Provider.of<EmployeeProvider>(
        context,
        listen: false,
      );
      employeeProvider.fetchEmployeeById(widget.employeeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    double columnWidth = (1.sw - 90.w) / 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: const Color(0xFF475569), size: 22.r),
        title: Text(
          widget.employeeName,
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
              ).fetchEmployeeById(widget.employeeId);
            },
            icon: Icon(Icons.refresh, color: Colors.black, size: 22.r),
          ),
        ],
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, employeeProvider, child) {
          if (employeeProvider.isSelectedLoading &&
              employeeProvider.selectedEmployee == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2353D0)),
            );
          }

          if (employeeProvider.selectedError != null &&
              employeeProvider.selectedEmployee == null) {
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
                      employeeProvider.selectedError!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton.icon(
                      onPressed: () => employeeProvider.fetchEmployeeById(widget.employeeId),
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

          final data = employeeProvider.selectedEmployee;

          return RefreshIndicator(
            onRefresh: () => employeeProvider.fetchEmployeeById(widget.employeeId),
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
                              backgroundColor: _getAvatarColor(data?.name),
                              child: Text(
                                _getInitials(data?.name ?? '??'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                ),
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
                                        'EMPLOYEE',
                                        const Color(0xFF2353D0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    data?.empCode ?? 'N/A',
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

                        if (employeeProvider.selectedEducationHistory.isEmpty)
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
                          ...employeeProvider.selectedEducationHistory.map(
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

                        if (employeeProvider.selectedPositionHistory.isEmpty)
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
                          ...employeeProvider.selectedPositionHistory.map(
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

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '??';
    
    String initials = '';
    for (var part in parts) {
      if (part.isNotEmpty) {
        initials += part[0];
      }
      if (initials.length >= 2) break;
    }
    
    return initials.isEmpty ? '??' : initials.toUpperCase();
  }
}

