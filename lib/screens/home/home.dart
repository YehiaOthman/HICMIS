import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/providers/auth_provider.dart';
import 'package:backtotrack/screens/home/widgets/new_leave_request_dialog.dart';
import 'widgets/leave_request_card.dart';
import 'widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.fetchMyAbsenceRequests();
    });
  }

  void _confirmDelete(BuildContext context, num id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Leave Request', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text('Are you sure you want to delete this leave request?', style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: GoogleFonts.poppins(color: const Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final res = await authProvider.deleteAbsenceRequest(id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(res['message'] ?? 'Deleted', style: GoogleFonts.poppins()),
                    backgroundColor: res['success'] ? const Color(0xFF22C55E) : Colors.redAccent,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Delete', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return const Color(0xFF22C55E);
      case 'rejected':
        return const Color(0xFFEF4444);
      case 'pending':
      default:
        return const Color(0xFFF59E0B);
    }
  }

  IconData _getAbsenceIcon(String? type) {
    final lower = type?.toLowerCase() ?? '';
    if (lower.contains('sick')) {
      return Icons.medical_services_outlined;
    } else if (lower.contains('annual') || lower.contains('vacation')) {
      return Icons.umbrella_outlined;
    } else {
      return Icons.event_note_outlined;
    }
  }

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
          IconButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).fetchMyAbsenceRequests();
            },
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
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
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final requests = authProvider.absenceRequests;

          return RefreshIndicator(
            onRefresh: () => authProvider.fetchMyAbsenceRequests(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                      Text('${requests.length} requests found', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (authProvider.isAbsenceLoading && requests.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xFF2353D0)),
                      ),
                    )

                  else if (requests.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.inbox_outlined, size: 48, color: Color(0xFFCBD5E1)),
                          const SizedBox(height: 10),
                          Text('No Leave Requests Yet', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF475569))),
                          const SizedBox(height: 5),
                          Text('Click "Request" to submit a new leave application.', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
                        ],
                      ),
                    )
                  else
                    ...requests.map(
                      (req) => LeaveRequestCard(
                        id: req.id,
                        type: req.absenceType ?? 'Leave Request',
                        dateRange: '${req.startDate ?? ''} - ${req.endDate ?? ''}',
                        reason: req.reason ?? 'N/A',
                        status: req.status ?? 'PENDING',
                        statusColor: _getStatusColor(req.status),
                        icon: _getAbsenceIcon(req.absenceType),
                        onDelete: req.id != null ? () => _confirmDelete(context, req.id!) : null,
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
}