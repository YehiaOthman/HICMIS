class Department {
  Department({this.id, this.nameEn, this.nameAr, this.code});

  Department.fromJson(dynamic json) {
    if (json is! Map) return;
    id = json['id'];
    nameEn = json['nameEn']?.toString();
    nameAr = json['nameAr']?.toString();
    code = json['code']?.toString();
  }

  num? id;
  String? nameEn;
  String? nameAr;
  String? code;
}
