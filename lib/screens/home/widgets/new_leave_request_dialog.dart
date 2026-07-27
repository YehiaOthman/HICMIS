import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewLeaveRequestDialog extends StatelessWidget {
  const NewLeaveRequestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Leave Request',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.close, color: Color(0xFF64748B), size: 20),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
              ),

              Flexible(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor: MaterialStateProperty.all(const Color(0xFFCBD5E1)),
                      thickness: MaterialStateProperty.all(6),
                      radius: const Radius.circular(10),
                    ),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('ABSENCE TYPE'),
                          const SizedBox(height: 8),
                          _buildDropdown(),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: _buildFieldGroup('START DATE', '07/17/2026'),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildFieldGroup('END DATE', '07/17/2026'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          _buildDurationRow(),

                          const SizedBox(height: 25),

                          _buildLabel('REASON'),
                          const SizedBox(height: 8),
                          _buildMultilineField('Please explain the reason for your leave...'),

                          const SizedBox(height: 25),

                          _buildLabel('ATTACHMENTS'),
                          const SizedBox(height: 8),
                          _buildUploadArea(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildButton(
                    label: 'Cancel',
                    isPrimary: false,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildButton(
                    label: 'Submit Request',
                    isPrimary: true,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF94A3B8),
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildFieldGroup(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF1E293B))),
              const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationRow() {
    return Row(
      children: [
        Text(
          'Requested Duration: ',
          style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF64748B)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF2353D0).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '1 day',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF2353D0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF2353D0).withOpacity(0.4), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'Annual Leave',
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2353D0)),
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
          isExpanded: true,
          items: ['Annual Leave', 'Sick Leave', 'Personal Leave']
              .map((String v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }

  Widget _buildMultilineField(String hint) {
    return TextFormField(
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF94A3B8)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF2353D0)),
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_upload_outlined, size: 36, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 10),
          Text(
            'DRAG & DROP OR CLICK TO UPLOAD',
            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8)),
          ),
          Text(
            'SUPPORTING DOCUMENTS (PDF, JPG, PNG)',
            style: GoogleFonts.poppins(fontSize: 9, color: const Color(0xFFCBD5E1)),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF2353D0) : const Color(0xFFF1F5F9),
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF475569),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}