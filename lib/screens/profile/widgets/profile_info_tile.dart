import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF94A3B8),
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}