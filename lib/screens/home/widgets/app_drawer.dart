import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  
  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isHR = authProvider.isHR;

    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFF2353D0), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.home_filled, color: Colors.white),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HICIMS', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('HR SYSTEM', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, letterSpacing: 1.1)),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 20),

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
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
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
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2353D0).withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: Icon(icon, color: isActive ? const Color(0xFF2353D0) : Colors.grey),
        title: Text(
          label,
          style: GoogleFonts.poppins(
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
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
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
              style: GoogleFonts.poppins(color: const Color(0xFF2353D0)),
            ),
          ),
        ],
      ),
    );
  }
}