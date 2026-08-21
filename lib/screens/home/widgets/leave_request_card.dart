import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveRequestCard extends StatefulWidget {
  final num? id;
  final String type;
  final String dateRange;
  final String reason;
  final String status;
  final Color statusColor;
  final IconData icon;
  final VoidCallback? onDelete;

  const LeaveRequestCard({
    super.key,
    this.id,
    required this.type,
    required this.dateRange,
    required this.reason,
    required this.status,
    required this.statusColor,
    required this.icon,
    this.onDelete,
  });

  @override
  State<LeaveRequestCard> createState() => _LeaveRequestCardState();
}

class _LeaveRequestCardState extends State<LeaveRequestCard> {
  bool _isExpanded = false;

  String _formatAbsenceType(String apiType) {
    Map<String, String> typeMap = {
      'ANNUAL_LEAVE': 'Annual Leave',
      'SICK_LEAVE': 'Sick Leave',
      'TIME_PERMISSION': 'Time Permission',
      'MATERNITY_LEAVE': 'Maternity Leave',
      'PATERNITY_LEAVE': 'Paternity Leave',
      'EMERGENCY_LEAVE': 'Emergency Leave',
      'UNPAID_LEAVE': 'Unpaid Leave',
      'BEREAVEMENT_LEAVE': 'Bereavement Leave',
    };
    return typeMap[apiType] ?? apiType;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          left: BorderSide(color: widget.statusColor, width: 4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2353D0).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: const Color(0xFF2353D0), size: 20),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_formatAbsenceType(widget.type), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(widget.dateRange, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: widget.statusColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    widget.status.toUpperCase(),
                    style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: widget.statusColor),
                  ),
                ),
                if (widget.onDelete != null && (widget.status.toLowerCase() == 'pending' || widget.status.toLowerCase() == 'draft')) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 20),
                    tooltip: 'Delete Request',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Reason: ${widget.reason}',
                style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF475569)),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                children: [
                  Icon(
                      _isExpanded ? Icons.close : Icons.add,
                      size: 14,
                      color: const Color(0xFF2353D0)
                  ),
                  Text(
                    _isExpanded ? ' Hide details' : ' View details',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF2353D0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            if (_isExpanded) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Divider(color: Color(0xFFF1F5F9)),
              ),

              _buildSectionTitle('ATTACHMENTS'),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.attach_file, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    'Files are securely stored.',
                    style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF475569)),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _buildSectionTitle('APPROVAL WORKFLOW STATUS'),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: widget.statusColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                            widget.status == 'rejected' ? Icons.close : Icons.check,
                            color: widget.statusColor,
                            size: 14
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                            children: [
                              const TextSpan(text: 'HR Manager ', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '(human resources HR)', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: widget.statusColor.withOpacity(0.2)),
                          ),
                          child: Text(
                            widget.status.toUpperCase(),
                            style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: widget.statusColor),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Jul 16, 2026, 12:35 PM',
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF94A3B8),
        letterSpacing: 1.1,
      ),
    );
  }
}