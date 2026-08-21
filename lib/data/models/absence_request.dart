class AbsenceRequest {
  num? id;
  num? employeeId;
  String? absenceType;
  String? startDate;
  String? endDate;
  String? reason;
  String? status;
  String? createdAt;

  AbsenceRequest({
    this.id,
    this.employeeId,
    this.absenceType,
    this.startDate,
    this.endDate,
    this.reason,
    this.status,
    this.createdAt,
  });

  factory AbsenceRequest.fromJson(dynamic json) {
    if (json is! Map) return AbsenceRequest();
    return AbsenceRequest(
      id: json['id'],
      employeeId: json['employeeId'],
      absenceType: json['absenceType']?.toString() ?? json['type']?.toString() ?? json['leaveType']?.toString() ?? 'Leave Request',
      startDate: json['startDate']?.toString() ?? json['from']?.toString(),
      endDate: json['endDate']?.toString() ?? json['to']?.toString(),
      reason: json['reason']?.toString() ?? json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? json['requestStatus']?.toString() ?? 'PENDING',
      createdAt: json['createdAt']?.toString() ?? json['createdDate']?.toString() ?? json['timestamp']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (employeeId != null) 'employeeId': employeeId,
      'absenceType': absenceType,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      if (status != null) 'status': status,
    };
  }
}
