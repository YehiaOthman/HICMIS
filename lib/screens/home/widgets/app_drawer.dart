import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  
  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isHR = authProvider.isHR || authProvider.isManager;

    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(color: const Color(0xFF2353D0), borderRadius: BorderRadius.circular(12.r)),
                    child: Icon(Icons.home_filled, color: Colors.white, size: 24.r),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('HICMIS', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18.sp)),
                        Text('HR SYSTEM', style: GoogleFonts.poppins(fontSize: 10.sp, color: Colors.grey, letterSpacing: 1.1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _drawerItem(
                      icon: Icons.person_outline,
                      label: "My Profile",
                      route: '/profile',
                      currentRoute: currentRoute,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/profile');
                      },
                    ),
                    _drawerItem(
                      icon: Icons.calendar_today_outlined,
                      label: "Leaves & Absences",
                      route: '/home',
                      currentRoute: currentRoute,
                      onTap: () {
                        Navigator.pop(context);
                        if (currentRoute != '/home') {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    ),
                    if (isHR)
                      _drawerItem(
                        icon: Icons.people_outline,
                        label: "Employees",
                        route: '/employees',
                        currentRoute: currentRoute,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/employees');
                        },
                      ),
                    _drawerItem(
                      icon: Icons.description_outlined,
                      label: "Documents",
                      route: null,
                      currentRoute: currentRoute,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: _drawerItem(
                icon: Icons.logout,
                label: "Logout",
                route: null,
                currentRoute: currentRoute,
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required String? route,
    required String? currentRoute,
    required VoidCallback onTap,
  }) {
    final isActive = route != null && currentRoute == route;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2353D0).withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        leading: Icon(icon, color: isActive ? const Color(0xFF2353D0) : Colors.grey, size: 22.r),
        title: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: isActive ? const Color(0xFF2353D0) : const Color(0xFF475569),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: const Color(0xFF64748B), fontSize: 14.sp),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(color: const Color(0xFF2353D0), fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
