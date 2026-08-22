import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/providers/employee_provider.dart';
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
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
      employeeProvider.fetchMyAbsenceRequests();
    });
  }

  void _confirmDelete(BuildContext context, num id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('Delete Leave Request', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18.sp)),
        content: Text('Are you sure you want to delete this leave request?', style: GoogleFonts.poppins(fontSize: 14.sp)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: GoogleFonts.poppins(color: const Color(0xFF64748B), fontSize: 14.sp)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
              final res = await employeeProvider.deleteAbsenceRequest(id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(res['message'] ?? 'Deleted', style: GoogleFonts.poppins(fontSize: 14.sp)),
                    backgroundColor: res['success'] ? const Color(0xFF22C55E) : Colors.redAccent,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('Delete', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14.sp)),
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
      drawer: const AppDrawer(currentRoute: '/home'),
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
            Text('HICIMS', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<EmployeeProvider>(context, listen: false).fetchMyAbsenceRequests();
            },
            icon: Icon(Icons.refresh, color: Colors.black, size: 22.r),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none, size: 22.r)),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xFFF1F5F9),
                child: Icon(Icons.person_outline, color: Colors.grey, size: 20.r),
              ),
            ),
          ),
        ],
      ),
      body: Consumer2<EmployeeProvider, AuthProvider>(
        builder: (context, employeeProvider, authProvider, child) {
          final requests = employeeProvider.absenceRequests;
          final isHR = authProvider.isHR;
          final pendingRequests = requests.where((req) => req.status?.toLowerCase() == 'pending').toList();

          return RefreshIndicator(
            onRefresh: () => employeeProvider.fetchMyAbsenceRequests(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                            Text('Leaves & Absences', style: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                            Text('Track entitlements and requests.', style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey)),
                          ],
                        ),
                      ),
                      if (!isHR || _selectedTabIndex == 0)
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const NewLeaveRequestDialog(),
                            );
                          },
                          icon: Icon(Icons.add, size: 18.r),
                          label: Text('Request', style: TextStyle(fontSize: 13.sp)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2353D0),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  
                  if (isHR)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTabIndex = 0),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: _selectedTabIndex == 0 ? const Color(0xFF2353D0) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'My Requests',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: _selectedTabIndex == 0 ? Colors.white : Colors.grey[600],
                                    fontWeight: _selectedTabIndex == 0 ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTabIndex = 1),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: _selectedTabIndex == 1 ? const Color(0xFF2353D0) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Pending Requests',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: _selectedTabIndex == 1 ? Colors.white : Colors.grey[600],
                                    fontWeight: _selectedTabIndex == 1 ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  SizedBox(height: 20.h),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(isHR && _selectedTabIndex == 1 ? pendingRequests : requests).length} requests found',
                        style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  if (employeeProvider.isAbsenceLoading && requests.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: const Center(
                        child: CircularProgressIndicator(color: Color(0xFF2353D0)),
                      ),
                    )

                  else if ((isHR && _selectedTabIndex == 1 ? pendingRequests : requests).isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(30.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.inbox_outlined, size: 48.r, color: const Color(0xFFCBD5E1)),
                          SizedBox(height: 10.h),
                          Text(
                            isHR && _selectedTabIndex == 1 ? 'No Pending Requests' : 'No Leave Requests Yet',
                            style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xFF475569)),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            isHR && _selectedTabIndex == 1 
                              ? 'There are no pending requests to review.' 
                              : 'Click "Request" to submit a new leave application.',
                            style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    ...(isHR && _selectedTabIndex == 1 ? pendingRequests : requests).map(
                      (req) => LeaveRequestCard(
                        id: req.id,
                        type: req.absenceType ?? 'Leave Request',
                        dateRange: '${req.startDate ?? ''} - ${req.endDate ?? ''}',
                        reason: req.reason ?? 'N/A',
                        status: req.status ?? 'PENDING',
                        statusColor: _getStatusColor(req.status),
                        icon: _getAbsenceIcon(req.absenceType),
                        onDelete: req.id != null && _selectedTabIndex == 0 ? () => _confirmDelete(context, req.id!) : null,
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

