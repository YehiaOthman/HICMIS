class AttendanceRecord {
  AttendanceRecord({
    this.id,
    this.employeeId,
    this.employeeName,
    this.date,
    this.checkIn,
    this.checkOut,
    this.payableDuration,
    this.manualEntry,
    this.enteredBy,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  AttendanceRecord.fromJson(dynamic json) {
    if (json is! Map) return;
    id = json['id'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName']?.toString();
    date = json['date']?.toString();
    checkIn = json['checkIn']?.toString();
    checkOut = json['checkOut']?.toString();
    payableDuration = json['payableDuration'];
    manualEntry = json['manualEntry'];
    enteredBy = json['enteredBy']?.toString();
    notes = json['notes']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  num? id;
  num? employeeId;
  String? employeeName;
  String? date;
  String? checkIn;
  String? checkOut;
  num? payableDuration;
  bool? manualEntry;
  String? enteredBy;
  String? notes;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['employeeId'] = employeeId;
    map['employeeName'] = employeeName;
    map['date'] = date;
    map['checkIn'] = checkIn;
    map['checkOut'] = checkOut;
    map['payableDuration'] = payableDuration;
    map['manualEntry'] = manualEntry;
    map['enteredBy'] = enteredBy;
    map['notes'] = notes;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}
