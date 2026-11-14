import 'attendance_record.dart';

class AttendanceRecordsResponse {
  AttendanceRecordsResponse({
    this.content,
    this.page,
    this.size,
    this.totalElements,
    this.totalPages,
    this.last,
    this.message,
    this.status,
  });

  AttendanceRecordsResponse.fromJson(dynamic json) {
    if (json is Map) {
      message = json['message']?.toString() ?? json['error']?.toString();
      status = json['status']?.toString();

      final data = json['data'];
      if (data is Map) {
        if (data['content'] is List) {
          content = (data['content'] as List)
              .map((item) => AttendanceRecord.fromJson(item))
              .toList();
        }
        page = data['page'];
        size = data['size'];
        totalElements = data['totalElements'];
        totalPages = data['totalPages'];
        last = data['last'];
      }
    }
  }

  List<AttendanceRecord>? content;
  num? page;
  num? size;
  num? totalElements;
  num? totalPages;
  bool? last;
  String? message;
  String? status;
}
