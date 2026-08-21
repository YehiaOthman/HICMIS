import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String id;
  final String code;
  final String department;
  final String hireDate;
  final Color avatarColor;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.id,
    required this.code,
    required this.department,
    required this.hireDate,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Avatar with Initials
          CircleAvatar(
            radius: 25,
            backgroundColor: avatarColor,
            child: Text(
              _getInitials(name),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 15),
          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Badge ID
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#$id',
                        style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _buildSmallInfo(Icons.badge_outlined, 'Code: $code'),
                const SizedBox(height: 4),
                _buildSmallInfo(Icons.business_outlined, department),
                const SizedBox(height: 4),
                _buildSmallInfo(null, 'Hired: $hireDate'),
              ],
            ),
          ),
          // View Button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2353D0).withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.visibility_outlined, color: Color(0xFF2353D0), size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfo(IconData? icon, String text) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: const Color(0xFFCBD5E1)),
          const SizedBox(width: 5),
        ],
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF94A3B8)),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    
    String initials = '';
    for (var part in parts) {
      if (part.isNotEmpty) {
        initials += part[0];
      }
      if (initials.length >= 2) break;
    }
    
    return initials.isEmpty ? '?' : initials.toUpperCase();
  }
}