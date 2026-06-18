/// نموذج بيانات المستخدم — مطابق لجدول users في قاعدة البيانات
class UserModel {
  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
  });

  final int userId;
  final String name;
  final String email;
  final int phone;
  final String? image;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: _parseInt(json['user_id']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: _parseInt(json['phone']),
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
