class EmployeeData {
  EmployeeData({
      this.id, 
      this.name, 
      this.nid, 
      this.empCode, 
      this.keycloakId, 
      this.departmentId, 
      this.departmentName, 
      this.directManagerId, 
      this.directManagerName, 
      this.hireDate, 
      this.phone, 
      this.gender, 
      this.title, 
      this.position, 
      this.maritalStatus, 
      this.birthLocation, 
      this.birthDate, 
      this.currentJobDescription, 
      this.normalCheckInTime, 
      this.checkInToleranceMinutes, 
      this.normalCheckOutTime, 
      this.checkOutToleranceMinutes, 
      this.halfDayDeductionThresholdMinutes, 
      this.minimumAttendanceDaysPerWeek, 
      this.socialInsuranceNumber, 
      this.socialInsuranceStartDate, 
      this.socialInsuranceStatusCode, 
      this.medicalInsuranceStatusCode, 
      this.taxOperationCode, 
      this.originalTaxRegNumber, 
      this.nationalityCode,});

  EmployeeData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    nid = json['nid'];
    empCode = json['empCode'];
    keycloakId = json['keycloakId'];
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
    directManagerId = json['directManagerId'];
    directManagerName = json['directManagerName'];
    hireDate = json['hireDate'];
    phone = json['phone'];
    gender = json['gender'];
    title = json['title'];
    position = json['position'];
    maritalStatus = json['maritalStatus'];
    birthLocation = json['birthLocation'];
    birthDate = json['birthDate'];
    currentJobDescription = json['currentJobDescription'];
    normalCheckInTime = json['normalCheckInTime'];
    checkInToleranceMinutes = json['checkInToleranceMinutes'];
    normalCheckOutTime = json['normalCheckOutTime'];
    checkOutToleranceMinutes = json['checkOutToleranceMinutes'];
    halfDayDeductionThresholdMinutes = json['halfDayDeductionThresholdMinutes'];
    minimumAttendanceDaysPerWeek = json['minimumAttendanceDaysPerWeek'];
    socialInsuranceNumber = json['socialInsuranceNumber'];
    socialInsuranceStartDate = json['socialInsuranceStartDate'];
    socialInsuranceStatusCode = json['socialInsuranceStatusCode'];
    medicalInsuranceStatusCode = json['medicalInsuranceStatusCode'];
    taxOperationCode = json['taxOperationCode'];
    originalTaxRegNumber = json['originalTaxRegNumber'];
    nationalityCode = json['nationalityCode'];
  }
  num? id;
  String? name;
  String? nid;
  String? empCode;
  String? keycloakId;
  num? departmentId;
  String? departmentName;
  dynamic directManagerId;
  dynamic directManagerName;
  String? hireDate;
  String? phone;
  String? gender;
  String? title;
  String? position;
  String? maritalStatus;
  String? birthLocation;
  String? birthDate;
  String? currentJobDescription;
  String? normalCheckInTime;
  num? checkInToleranceMinutes;
  String? normalCheckOutTime;
  num? checkOutToleranceMinutes;
  num? halfDayDeductionThresholdMinutes;
  num? minimumAttendanceDaysPerWeek;
  dynamic socialInsuranceNumber;
  dynamic socialInsuranceStartDate;
  dynamic socialInsuranceStatusCode;
  dynamic medicalInsuranceStatusCode;
  dynamic taxOperationCode;
  dynamic originalTaxRegNumber;
  dynamic nationalityCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['nid'] = nid;
    map['empCode'] = empCode;
    map['keycloakId'] = keycloakId;
    map['departmentId'] = departmentId;
    map['departmentName'] = departmentName;
    map['directManagerId'] = directManagerId;
    map['directManagerName'] = directManagerName;
    map['hireDate'] = hireDate;
    map['phone'] = phone;
    map['gender'] = gender;
    map['title'] = title;
    map['position'] = position;
    map['maritalStatus'] = maritalStatus;
    map['birthLocation'] = birthLocation;
    map['birthDate'] = birthDate;
    map['currentJobDescription'] = currentJobDescription;
    map['normalCheckInTime'] = normalCheckInTime;
    map['checkInToleranceMinutes'] = checkInToleranceMinutes;
    map['normalCheckOutTime'] = normalCheckOutTime;
    map['checkOutToleranceMinutes'] = checkOutToleranceMinutes;
    map['halfDayDeductionThresholdMinutes'] = halfDayDeductionThresholdMinutes;
    map['minimumAttendanceDaysPerWeek'] = minimumAttendanceDaysPerWeek;
    map['socialInsuranceNumber'] = socialInsuranceNumber;
    map['socialInsuranceStartDate'] = socialInsuranceStartDate;
    map['socialInsuranceStatusCode'] = socialInsuranceStatusCode;
    map['medicalInsuranceStatusCode'] = medicalInsuranceStatusCode;
    map['taxOperationCode'] = taxOperationCode;
    map['originalTaxRegNumber'] = originalTaxRegNumber;
    map['nationalityCode'] = nationalityCode;
    return map;
  }

}