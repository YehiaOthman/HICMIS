class AbsenceRequest {
  num? id;
  num? employeeId;
  String? employeeName;
  String? absenceType;
  String? startDate;
  String? endDate;
  num? totalDays;
  String? reason;
  String? status;
  String? createdAt;
  num? parentAbsenceId;
  String? breakFromDate;
  List<ApprovalStep> approvalSteps;

  AbsenceRequest({
    this.id,
    this.employeeId,
    this.employeeName,
    this.absenceType,
    this.startDate,
    this.endDate,
    this.totalDays,
    this.reason,
    this.status,
    this.createdAt,
    this.parentAbsenceId,
    this.breakFromDate,
    this.approvalSteps = const [],
  });

  factory AbsenceRequest.fromJson(dynamic json) {
    if (json is! Map) return AbsenceRequest();
    return AbsenceRequest(
      id: json['id'],
      employeeId: json['employeeId'],
      employeeName: json['employeeName']?.toString(),
      absenceType: json['absenceType']?.toString() ?? json['type']?.toString() ?? json['leaveType']?.toString() ?? 'Leave Request',
      startDate: json['startDate']?.toString() ?? json['from']?.toString(),
      endDate: json['endDate']?.toString() ?? json['to']?.toString(),
      totalDays: json['totalDays'],
      reason: json['reason']?.toString() ?? json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? json['requestStatus']?.toString() ?? 'PENDING',
      createdAt: json['createdAt']?.toString() ?? json['createdDate']?.toString() ?? json['timestamp']?.toString(),
      parentAbsenceId: json['parentAbsenceId'],
      breakFromDate: json['breakFromDate']?.toString(),
      approvalSteps: json['approvalSteps'] is List
          ? (json['approvalSteps'] as List).map((e) => ApprovalStep.fromJson(e)).toList()
          : [],
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

class ApprovalStep {
  num? stepOrder;
  String? approverRole;
  String? status;
  String? approverName;
  String? comment;
  String? decidedAt;

  ApprovalStep({
    this.stepOrder,
    this.approverRole,
    this.status,
    this.approverName,
    this.comment,
    this.decidedAt,
  });

  factory ApprovalStep.fromJson(dynamic json) {
    if (json is! Map) return ApprovalStep();
    return ApprovalStep(
      stepOrder: json['stepOrder'],
      approverRole: json['approverRole']?.toString(),
      status: json['status']?.toString(),
      approverName: json['approverName']?.toString(),
      comment: json['comment']?.toString(),
      decidedAt: json['decidedAt']?.toString(),
    );
  }
}
