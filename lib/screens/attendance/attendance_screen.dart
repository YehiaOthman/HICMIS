import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:backtotrack/screens/home/widgets/app_drawer.dart';
import 'package:backtotrack/providers/attendance_provider.dart';
import 'package:backtotrack/data/models/attendance_record.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRecords();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<AttendanceProvider>(context, listen: false);
      if (provider.hasMore && !provider.isLoading) {
        provider.fetchRecords(search: _searchController.text, reset: false);
      }
    }
  }

  void _fetchRecords() {
    final provider = Provider.of<AttendanceProvider>(context, listen: false);
    provider.fetchRecords(search: _searchController.text);
  }

  void _onSearchChanged(String value) {
    setState(() {});
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == value) {
        _fetchRecords();
      }
    });
  }

  Future<void> _pickDate() async {
    final provider = Provider.of<AttendanceProvider>(context, listen: false);
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      provider.setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      drawer: const AppDrawer(currentRoute: '/attendance'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: const Color(0xFF475569), size: 22.r),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(color: const Color(0xFF2353D0), borderRadius: BorderRadius.circular(8.r)),
              child: Icon(Icons.home_filled, color: Colors.white, size: 20.r),
            ),
            SizedBox(width: 10.w),
            Text('HICMIS', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchRecords(),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(20.r),
          child: Consumer<AttendanceProvider>(
            builder: (context, provider, child) {
              final records = provider.records;
              final isLoading = provider.isLoading;
              final total = provider.totalRecords;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Attendance', style: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                  Text('Employees attendance records for the selected date.',
                      style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey)),

                  SizedBox(height: 25.h),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10.r)],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            style: GoogleFonts.poppins(fontSize: 14.sp),
                            decoration: InputDecoration(
                              hintText: 'Search by name or code...',
                              hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14.sp),
                              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.r),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          height: 50.r,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2353D0),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, color: Colors.white, size: 18.r),
                              SizedBox(width: 6.w),
                              Text(
                                _formatDisplayDate(provider.selectedDate),
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 25.h),

                  Text(
                    total != null ? '$total records found' : (isLoading ? 'Loading...' : ''),
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13.sp),
                  ),
                  SizedBox(height: 15.h),

                  if (isLoading && records.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: const Center(
                        child: CircularProgressIndicator(color: Color(0xFF2353D0)),
                      ),
                    )
                  else if (records.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(30.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.access_time, size: 48.r, color: const Color(0xFFCBD5E1)),
                          SizedBox(height: 10.h),
                          Text(
                            'No Attendance Records',
                            style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xFF475569)),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            provider.error ??
                                (_searchController.text.isEmpty
                                    ? 'No records for this date.'
                                    : 'Try adjusting your search.'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        ...records.map(_buildRecordCard),
                        if (isLoading)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: const Center(
                              child: CircularProgressIndicator(color: Color(0xFF2353D0)),
                            ),
                          ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRecordCard(AttendanceRecord record) {
    final name = record.employeeName ?? 'Unknown';
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10.r)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: _getAvatarColor(name),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
                ),
              ),
              if (record.manualEntry == true)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Manual',
                    style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w600, color: const Color(0xFFF59E0B)),
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(child: _buildInfo('Check In', _formatTime(record.checkIn))),
              Expanded(child: _buildInfo('Check Out', _formatTime(record.checkOut))),
              Expanded(child: _buildInfo('Payable', record.payableDuration?.toStringAsFixed(2) ?? '--')),
            ],
          ),
          if (record.notes != null && record.notes!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              record.notes!,
              style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF94A3B8))),
        SizedBox(height: 2.h),
        Text(value, style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF475569))),
      ],
    );
  }

  String _formatTime(String? value) {
    if (value == null || value.isEmpty) return '--';
    final dt = DateTime.tryParse(value);
    if (dt == null) return value;
    final local = dt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatDisplayDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  Color _getAvatarColor(String? name) {
    if (name == null || name.isEmpty) return const Color(0xFF94A3B8);
    final colors = [
      const Color(0xFF2353D0),
      const Color(0xFF00C1A3),
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
    ];
    final index = name.hashCode % colors.length;
    return colors[index.abs()];
  }
}
