/// نموذج شركة النقل — مطابق لجدول company في قاعدة البيانات
class CompanyModel {
  const CompanyModel({
    required this.companyId,
    required this.companyName,
    required this.destinations,
    required this.phone,
    required this.email,
    required this.registrationNumber,
    required this.isActive,
  });

  final int companyId;
  final String companyName;
  final String destinations;
  final int phone;
  final String email;
  final int registrationNumber;
  final bool isActive;

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyId: _parseInt(json['company_id']),
      companyName: json['company_name']?.toString().trim() ?? '',
      destinations: json['destinations']?.toString().trim() ?? '',
      phone: _parseInt(json['phone']),
      email: json['email']?.toString().trim() ?? '',
      registrationNumber: _parseInt(json['registration_number']),
      isActive: _parseInt(json['status']) == 1,
    );
  }

  /// عرض رقم الهاتف بصيغة محلية
  String get displayPhone {
    final digits = phone.toString();
    if (digits.length == 9) return '0$digits';
    return digits;
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
