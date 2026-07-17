import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String total;
  final Color color;

  const LeaveSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '/ $total days left',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}