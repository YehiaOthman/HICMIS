
import 'package:backtotrack/screens/home/widgets/new_leave_request_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/leave_summary_card.dart';
import 'widgets/leave_request_card.dart';
import 'widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF475569)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: const Color(0xFF2353D0), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.home_filled, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text('HICIMS', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),

          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: CircleAvatar(
                backgroundColor: Color(0xFFF1F5F9),
                child: Icon(Icons.person_outline, color: Colors.grey),
              ),
            ),
          ),
        ],
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
                    Text('Leaves & Absences', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('Track entitlements and requests.', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const NewLeaveRequestDialog(),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Request'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2353D0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('2 requests found', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
               /* Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, size: 16, color: Colors.grey),
                      Text(' Filter', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                )*/
              ],
            ),
            const SizedBox(height: 20),
            const LeaveRequestCard(
              type: 'Annual Leave',
              dateRange: 'Jul 6, 2026 - Aug 6, 2026',
              reason: 'break',
              status: 'rejected',
              statusColor: Color(0xFFEF4444),
              icon: Icons.umbrella_outlined,
            ),
            const LeaveRequestCard(
              type: 'Sick Leave',
              dateRange: 'Jun 10, 2026 - Jun 11, 2026',
              reason: 'illness',
              status: 'approved',
              statusColor: Color(0xFF22C55E),
              icon: Icons.info_outline,
            ),
          ],
        ),
      ),
    );
  }
}