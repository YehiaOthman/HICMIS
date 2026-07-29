import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/providers/employee_provider.dart';
import 'package:backtotrack/providers/auth_provider.dart';
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
      final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
      employeeProvider.fetchEmployeeProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    double columnWidth = (MediaQuery.of(context).size.width - 80) / 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Account Profile',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<EmployeeProvider>(context, listen: false).fetchEmployeeProfile();
            },
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, employeeProvider, child) {
          if (employeeProvider.isLoading && employeeProvider.employeeData == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2353D0)),
            );
          }

          if (employeeProvider.errorMessage != null && employeeProvider.employeeData == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text(
                      employeeProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => employeeProvider.fetchEmployeeProfile(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2353D0),
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          final data = employeeProvider.employeeData;
          final authProvider = Provider.of<AuthProvider>(context, listen: false);

          return RefreshIndicator(
            onRefresh: () => employeeProvider.fetchEmployeeProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person_outline, size: 35, color: Color(0xFF94A3B8)),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 10,
                                    children: [
                                      Text(
                                        data?.name ?? 'Employee',
                                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      _buildStatusChip('ACTIVE ACCOUNT', Colors.green),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  _buildStatusChip(data?.position ?? 'EMPLOYEE',Color(0xFF2353D0)),
                                  const SizedBox(height: 4),
                                  Text(
                                    authProvider.username != null ? '${authProvider.username}@xtra.com' : 'employee@xtra.com',
                                    style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PERSONAL INFORMATION',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2353D0),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Wrap(
                                runSpacing: 20,
                                spacing: 10,
                                children: [
                                  SizedBox(
                                    width: columnWidth,
                                    child: ProfileInfoTile(
                                      label: 'Username ID',
                                      value: authProvider.username ?? (data?.empCode != null ? '${data!.empCode}' : 'N/A'),
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
                                      value: data?.directManagerName?.toString() ?? 'N/A',
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
                              const SizedBox(height: 20),
                              ProfileInfoTile(
                                label: 'Job Description',
                                value: data?.currentJobDescription ?? 'N/A',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (employeeProvider.educationHistory.isEmpty)
                          HistoryCard(
                            icon: Icons.school_outlined,
                            title: 'Education History',
                            subtitle: 'Manage degrees, institutions, and years of study.',
                            child: Text(
                              'No education history records found.',
                              style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF64748B)),
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
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  if (edu.institution != null && edu.institution!.isNotEmpty)
                                    Text(
                                      edu.institution!,
                                      style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B)),
                                    ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${edu.startDate ?? ''} ${(edu.endDate != null && edu.endDate!.isNotEmpty) ? '- ${edu.endDate}' : ''}'.trim(),
                                    style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        if (employeeProvider.positionHistory.isEmpty)
                          HistoryCard(
                            icon: Icons.work_outline,
                            title: 'Position History',
                            subtitle: 'Manage positions, departments, and tenure dates.',
                            child: Text(
                              'No position history records found.',
                              style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF64748B)),
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
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  if (pos.departmentName != null && pos.departmentName!.isNotEmpty)
                                    Text(
                                      pos.departmentName!,
                                      style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B)),
                                    ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${pos.startDate ?? ''} ${(pos.endDate != null && pos.endDate!.isNotEmpty) ? '- ${pos.endDate}' : '- Present'}',
                                    style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF94A3B8)),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Text(text, style: GoogleFonts.poppins(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Widget _buildRoleChip(String text) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF00C1A3),
  //       borderRadius: BorderRadius.circular(4),
  //     ),
  //     child: Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
  //   );
  // }
}
