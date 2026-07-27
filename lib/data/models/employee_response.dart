import 'employee_data.dart';

class EmployeeResponse {
  EmployeeResponse({
      this.transactionId, 
      this.timestamp, 
      this.status, 
      this.message, 
      this.data,});

  EmployeeResponse.fromJson(dynamic json) {
    transactionId = json['transactionId'];
    timestamp = json['timestamp'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? EmployeeData.fromJson(json['data']) : null;
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