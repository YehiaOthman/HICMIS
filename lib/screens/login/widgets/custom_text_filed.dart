import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled({
    super.key,
    required this.label,
    required this.title,
    required this.validator,
    required this.controller,
    required this.icon,
    this.isPassword = false,
  });

  final String label;
  final String title;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF94A3B8),
            fontSize: 11,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: isPassword,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            prefixIcon: Icon(icon, color: Colors.grey.withOpacity(0.5), size: 20),
            suffixIcon: isPassword
                ? Icon(Icons.visibility_outlined, color: Colors.grey.withOpacity(0.5), size: 20)
                : null,
            hintText: title,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey.withOpacity(0.5),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF2353D0), width: 1.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}