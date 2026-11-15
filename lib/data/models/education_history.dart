class EducationHistory {
  num? id;
  num? employeeId;
  String? degree;
  String? institution;
  String? major;
  String? startDate;
  String? endDate;
  String? gpa;

  EducationHistory({
    this.id,
    this.employeeId,
    this.degree,
    this.institution,
    this.major,
    this.startDate,
    this.endDate,
    this.gpa,
  });

  factory EducationHistory.fromJson(dynamic json) {
    if (json is! Map) return EducationHistory();
    return EducationHistory(
      id: json['id'],
      employeeId: json['employeeId'],
      degree: json['degree']?.toString() ?? json['degreeName']?.toString() ?? json['degreeTitle']?.toString() ?? json['educationLevel']?.toString() ?? json['title']?.toString(),
      institution: json['institution']?.toString() ?? json['institutionName']?.toString() ?? json['university']?.toString() ?? json['school']?.toString() ?? json['schoolName']?.toString(),
      major: json['major']?.toString() ?? json['fieldOfStudy']?.toString() ?? json['specialization']?.toString() ?? json['department']?.toString(),
      startDate: json['startDate']?.toString() ?? json['startYear']?.toString() ?? json['from']?.toString(),
      endDate: json['endDate']?.toString() ?? json['endYear']?.toString() ?? json['to']?.toString(),
      gpa: json['gpa']?.toString() ?? json['grade']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'degree': degree,
      'institution': institution,
      'major': major,
      'startDate': startDate,
      'endDate': endDate,
      'gpa': gpa,
    };
  }
}
