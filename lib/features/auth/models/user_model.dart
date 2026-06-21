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

  /// استخراج المستخدم من استجابات الـ API بصيغ مختلفة
  static UserModel? tryParseFromResponse(dynamic data) {
    if (data is! Map) return null;

    final map = Map<String, dynamic>.from(data);

    if (map.containsKey('user') && map['user'] is Map) {
      return UserModel.fromJson(Map<String, dynamic>.from(map['user']));
    }
    if (map.containsKey('data') && map['data'] is Map) {
      return UserModel.fromJson(Map<String, dynamic>.from(map['data']));
    }
    if (map.containsKey('user_id')) {
      return UserModel.fromJson(map);
    }

    return null;
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

  UserModel copyWith({
    int? userId,
    String? name,
    String? email,
    int? phone,
    String? image,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
    );
  }

  /// عرض رقم الهاتف بصيغة محلية (09XXXXXXXX)
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
