import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomPasswordTextFiled extends StatefulWidget {
  const CustomPasswordTextFiled({
    super.key,
    required this.label,
    required this.title,
    required this.validator,
    required this.controller,
    required this.icon,
  });

  final String label;
  final String title;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final IconData icon;

  @override
  State<CustomPasswordTextFiled> createState() => _CustomPasswordTextFiledState();
}

class _CustomPasswordTextFiledState extends State<CustomPasswordTextFiled> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF94A3B8), // Gray label color
            fontSize: 11,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: _isObscured,
          controller: widget.controller,
          validator: widget.validator,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC), // Light grey fill
            prefixIcon: Icon(widget.icon, color: Colors.grey.withOpacity(0.5), size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey.withOpacity(0.5),
                size: 20,
              ),
              onPressed: () => setState(() => _isObscured = !_isObscured),
            ),
            hintText: widget.title,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey.withOpacity(0.5),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ],
    );
  }
}