import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/profile_info_tile.dart';
import 'widgets/history_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
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
                                Text('employee employee',
                                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                                _buildStatusChip('ACTIVE ACCOUNT', const Color(0xFF00C1A3)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildRoleChip('EMPLOYEE'),
                            const SizedBox(height: 8),
                            Text('employee@xtra.com',
                                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF64748B))),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),

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
                        Text('PERSONAL INFORMATION',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2353D0),
                                letterSpacing: 1.2)),
                        const SizedBox(height: 25),
                        Wrap(
                          runSpacing: 20,
                          spacing: 10,
                          children: [
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'Username ID', value: 'employee')),
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'Employee Code', value: '3')),
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'National ID (NID)', value: '30309050100613')),
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'Phone Number', value: '12345678900')),
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'Assigned Department', value: 'Human Resources')),
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'Direct Manager', value: 'N/A')),
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'Employment Onboarding', value: '2026-07-06')),
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'Clearance Roles', value: 'employee (System clearance granted)')),
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'Title', value: 'Dr.')),
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'Job Position', value: 'مدرس')),
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'Marital Status', value: 'Married')),
                            SizedBox(width: columnWidth, child: const ProfileInfoTile(label: 'Place of Birth', value: 'القاهرة')),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const ProfileInfoTile(label: 'Job Description', value: 'الوصف الوظيفي'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  HistoryCard(
                    icon: Icons.school_outlined,
                    title: 'Education History',
                    subtitle: 'Manage degrees, institutions, and years of study.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('بكالوريوس - علوم حاسب',
                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('جامعة القاهرة',
                            style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B))),
                        const SizedBox(height: 10),
                        Text('2021 - 2025',
                            style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF94A3B8))),
                      ],
                    ),
                  ),

                  HistoryCard(
                    icon: Icons.work_outline,
                    title: 'Position History',
                    subtitle: 'Manage positions, departments, and tenure dates.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('جونيور',
                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        Text('Human Resources',
                            style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B))),
                        Text('2025-07-15 - 2026-07-15',
                            style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: GoogleFonts.poppins(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRoleChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF00C1A3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}