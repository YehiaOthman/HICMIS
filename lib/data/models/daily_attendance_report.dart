class DailyAttendanceReportResponse {
  DailyAttendanceReportResponse({this.data, this.message, this.status});

  DailyAttendanceReportResponse.fromJson(dynamic json) {
    if (json is Map) {
      message = json['message']?.toString() ?? json['error']?.toString();
      status = json['status']?.toString();
      if (json['data'] is Map) {
        data = DailyAttendanceReport.fromJson(json['data']);
      }
    }
  }

  DailyAttendanceReport? data;
  String? message;
  String? status;
}

class DailyAttendanceReport {
  DailyAttendanceReport({
    this.date,
    this.dayOfWeek,
    this.nonWorkingDay,
    this.future,
    this.summary,
    this.rows,
  });

  DailyAttendanceReport.fromJson(dynamic json) {
    if (json is! Map) return;
    date = json['date']?.toString();
    dayOfWeek = json['dayOfWeek']?.toString();
    nonWorkingDay = json['nonWorkingDay'];
    future = json['future'];
    if (json['summary'] is Map) {
      summary = DailyAttendanceSummary.fromJson(json['summary']);
    }
    if (json['rows'] is List) {
      rows = (json['rows'] as List)
          .map((item) => DailyAttendanceRow.fromJson(item))
          .toList();
    }
  }

  String? date;
  String? dayOfWeek;
  bool? nonWorkingDay;
  bool? future;
  DailyAttendanceSummary? summary;
  List<DailyAttendanceRow>? rows;
}

class DailyAttendanceSummary {
  DailyAttendanceSummary.fromJson(dynamic json) {
    if (json is! Map) return;
    totalEmployees = json['totalEmployees'];
    completeDay = json['completeDay'];
    halfDay = json['halfDay'];
    inProgress = json['inProgress'];
    absent = json['absent'];
    onLeave = json['onLeave'];
    nonWorkingDay = json['nonWorkingDay'];
    late = json['late'];
    missingCheckOut = json['missingCheckOut'];
    totalPayableHours = json['totalPayableHours'];
    attendanceRatePercent = json['attendanceRatePercent'];
  }

  num? totalEmployees;
  num? completeDay;
  num? halfDay;
  num? inProgress;
  num? absent;
  num? onLeave;
  num? nonWorkingDay;
  num? late;
  num? missingCheckOut;
  num? totalPayableHours;
  num? attendanceRatePercent;
}

class DailyAttendanceRow {
  DailyAttendanceRow.fromJson(dynamic json) {
    if (json is! Map) return;
    employeeId = json['employeeId'];
    empCode = json['empCode']?.toString();
    employeeName = json['employeeName']?.toString();
    department = json['department']?.toString();
    position = json['position']?.toString();
    status = json['status']?.toString();
    checkIn = json['checkIn']?.toString();
    checkOut = json['checkOut']?.toString();
    payableHours = json['payableHours'];
    expectedCheckIn = json['expectedCheckIn']?.toString();
    expectedCheckOut = json['expectedCheckOut']?.toString();
    lateMinutes = json['lateMinutes'];
    earlyLeaveMinutes = json['earlyLeaveMinutes'];
    absenceType = json['absenceType']?.toString();
    absenceRequestId = json['absenceRequestId'];
  }

  num? employeeId;
  String? empCode;
  String? employeeName;
  String? department;
  String? position;
  String? status;
  String? checkIn;
  String? checkOut;
  num? payableHours;
  String? expectedCheckIn;
  String? expectedCheckOut;
  num? lateMinutes;
  num? earlyLeaveMinutes;
  String? absenceType;
  num? absenceRequestId;
}
