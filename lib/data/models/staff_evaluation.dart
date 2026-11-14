class StaffEvaluation {
  StaffEvaluation.fromJson(dynamic json) {
    if (json is! Map) return;
    id = json['id'];
    form = json['form']?.toString();
    employeeId = json['employeeId'];
    employeeName = json['employeeName']?.toString();
    evaluatorName = json['evaluatorName']?.toString();
    evaluationDate = json['evaluationDate']?.toString();
    semesterId = json['semesterId'];
    semesterLabel = json['semesterLabel']?.toString();
    committeeId = json['committeeId'];
    committeeName = json['committeeName']?.toString();
    qualityStandardId = json['qualityStandardId'];
    qualityStandardNumber = json['qualityStandardNumber'];
    qualityStandardName = json['qualityStandardName']?.toString();
    totalScore = json['totalScore'];
    maxScore = json['maxScore'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  num? id;
  String? form;
  num? employeeId;
  String? employeeName;
  String? evaluatorName;
  String? evaluationDate;
  num? semesterId;
  String? semesterLabel;
  num? committeeId;
  String? committeeName;
  num? qualityStandardId;
  num? qualityStandardNumber;
  String? qualityStandardName;
  num? totalScore;
  num? maxScore;
  String? createdAt;
  String? updatedAt;
}

class StaffEvaluationsResponse {
  StaffEvaluationsResponse({
    this.content,
    this.page,
    this.size,
    this.totalElements,
    this.totalPages,
    this.last,
    this.message,
    this.status,
  });

  StaffEvaluationsResponse.fromJson(dynamic json) {
    if (json is Map) {
      message = json['message']?.toString() ?? json['error']?.toString();
      status = json['status']?.toString();

      final data = json['data'];
      if (data is Map) {
        if (data['content'] is List) {
          content = (data['content'] as List)
              .map((item) => StaffEvaluation.fromJson(item))
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

  List<StaffEvaluation>? content;
  num? page;
  num? size;
  num? totalElements;
  num? totalPages;
  bool? last;
  String? message;
  String? status;
}

class EvaluationFormDefinition {
  EvaluationFormDefinition.fromJson(dynamic json) {
    if (json is! Map) return;
    form = json['form']?.toString();
    needsCommittee = json['needsCommittee'] == true;
    needsStandard = json['needsStandard'] == true;
    if (json['fields'] is List) {
      fields = (json['fields'] as List)
          .map((item) => EvaluationField.fromJson(item))
          .toList();
    }
  }

  String? form;
  bool needsCommittee = false;
  bool needsStandard = false;
  List<EvaluationField> fields = [];
}

class EvaluationField {
  EvaluationField.fromJson(dynamic json) {
    if (json is! Map) return;
    key = json['key']?.toString();
    type = json['type']?.toString();
    group = json['group']?.toString();
    labelAr = json['labelAr']?.toString();
    labelEn = json['labelEn']?.toString();
    required = json['required'] == true;
    if (json['options'] is List) {
      options = (json['options'] as List)
          .map((item) => EvaluationOption.fromJson(item))
          .toList();
    }
    dependsOn = json['dependsOn']?.toString();
    dependsOnValue = json['dependsOnValue']?.toString();
  }

  String? key;
  String? type;
  String? group;
  String? labelAr;
  String? labelEn;
  bool required = false;
  List<EvaluationOption> options = [];
  String? dependsOn;
  String? dependsOnValue;
}

class EvaluationOption {
  EvaluationOption.fromJson(dynamic json) {
    if (json is! Map) return;
    code = json['code']?.toString();
    labelAr = json['labelAr']?.toString();
    labelEn = json['labelEn']?.toString();
    points = json['points'];
  }

  String? code;
  String? labelAr;
  String? labelEn;
  num? points;
}

class Evaluatee {
  Evaluatee.fromJson(dynamic json) {
    if (json is! Map) return;
    employeeId = json['employeeId'];
    name = json['name']?.toString();
    empCode = json['empCode']?.toString();
    academicRole = json['academicRole']?.toString();
  }

  num? employeeId;
  String? name;
  String? empCode;
  String? academicRole;
}

class Semester {
  Semester.fromJson(dynamic json) {
    if (json is! Map) return;
    id = json['id'];
    label = json['label']?.toString();
    startDate = json['startDate']?.toString();
    endDate = json['endDate']?.toString();
    active = json['active'] == true;
  }

  num? id;
  String? label;
  String? startDate;
  String? endDate;
  bool active = false;
}

class EvaluationCommittee {
  EvaluationCommittee.fromJson(dynamic json) {
    if (json is! Map) return;
    id = json['id'];
    nameAr = json['nameAr']?.toString();
    nameEn = json['nameEn']?.toString();
    active = json['active'] == true;
  }

  num? id;
  String? nameAr;
  String? nameEn;
  bool active = false;
}

class QualityStandard {
  QualityStandard.fromJson(dynamic json) {
    if (json is! Map) return;
    id = json['id'];
    number = json['number'];
    nameAr = json['nameAr']?.toString();
    nameEn = json['nameEn']?.toString();
    active = json['active'] == true;
  }

  num? id;
  num? number;
  String? nameAr;
  String? nameEn;
  bool active = false;
}
