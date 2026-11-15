import 'employee_data.dart';

class EmployeesListResponse {
  EmployeesListResponse({
    this.content,
    this.page,
    this.size,
    this.totalElements,
    this.totalPages,
    this.last,
    this.message,
    this.status,
  });

  EmployeesListResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic> || json is Map) {
      message = json['message']?.toString() ?? json['error']?.toString();
      status = json['status']?.toString();
      
      if (json['data'] != null) {
        final data = json['data'];
        if (data is Map) {
          if (data['content'] != null && data['content'] is List) {
            content = (data['content'] as List)
                .map((item) => EmployeeData.fromJson(item))
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
  }

  List<EmployeeData>? content;
  num? page;
  num? size;
  num? totalElements;
  num? totalPages;
  bool? last;
  String? message;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content != null) {
      map['content'] = content?.map((v) => v.toJson()).toList();
    }
    map['page'] = page;
    map['size'] = size;
    map['totalElements'] = totalElements;
    map['totalPages'] = totalPages;
    map['last'] = last;
    map['message'] = message;
    map['status'] = status;
    return map;
  }
}
