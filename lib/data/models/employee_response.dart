import 'employee_data.dart';

class EmployeeResponse {
  EmployeeResponse({
      this.transactionId, 
      this.timestamp, 
      this.status, 
      this.message, 
      this.data,});

  EmployeeResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic> || json is Map) {
      transactionId = json['transactionId']?.toString();
      timestamp = json['timestamp']?.toString();
      status = json['status']?.toString();
      message = json['message']?.toString() ?? json['error']?.toString();
      
      if (json['data'] != null) {
        data = EmployeeData.fromJson(json['data']);
      } else if (json['id'] != null || json['empCode'] != null || json['name'] != null || json['nid'] != null) {
        data = EmployeeData.fromJson(json);
      }
    }
  }

  String? transactionId;
  String? timestamp;
  String? status;
  String? message;
  EmployeeData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['transactionId'] = transactionId;
    map['timestamp'] = timestamp;
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}