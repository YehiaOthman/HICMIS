import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent, // Prevents grey tint
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

          // --- UPDATED ITEMS ---
          _drawerItem(
            icon: Icons.person_outline,
            label: "My Profile",
            isActive: false,
            onTap: () {
              Navigator.pop(context); // Close the drawer first
              Navigator.pushNamed(context, '/profile'); // Go to profile
            },
          ),
          _drawerItem(
            icon: Icons.calendar_today_outlined,
            label: "Leaves & Absences",
            isActive: true,
            onTap: () => Navigator.pop(context), // Already here, just close
          ),
          _drawerItem(
            icon: Icons.description_outlined,
            label: "Documents",
            isActive: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // Updated helper to include onTap
  Widget _drawerItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
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
}