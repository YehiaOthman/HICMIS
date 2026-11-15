class PositionHistory {
  num? id;
  num? employeeId;
  String? title;
  String? departmentName;
  String? startDate;
  String? endDate;
  String? notes;

  PositionHistory({
    this.id,
    this.employeeId,
    this.title,
    this.departmentName,
    this.startDate,
    this.endDate,
    this.notes,
  });

  factory PositionHistory.fromJson(dynamic json) {
    if (json is! Map) return PositionHistory();
    return PositionHistory(
      id: json['id'],
      employeeId: json['employeeId'],
      title: json['title']?.toString() ?? json['position']?.toString() ?? json['positionName']?.toString() ?? json['jobTitle']?.toString() ?? json['titleName']?.toString(),
      departmentName: json['departmentName']?.toString() ?? json['department']?.toString() ?? json['departmentTitle']?.toString(),
      startDate: json['startDate']?.toString() ?? json['startYear']?.toString() ?? json['from']?.toString(),
      endDate: json['endDate']?.toString() ?? json['endYear']?.toString() ?? json['to']?.toString(),
      notes: json['notes']?.toString() ?? json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'title': title,
      'departmentName': departmentName,
      'startDate': startDate,
      'endDate': endDate,
      'notes': notes,
    };
  }
}
