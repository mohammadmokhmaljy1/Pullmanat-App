/// دوال التحقق من صحة المدخلات — رسائل الخطأ مطابقة لتصميم Figma
class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegex = RegExp(
    r'^(\+963|00963|0)?[\s-]?9\d{8}$',
  );

  /// التحقق من الاسم الكامل
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.trim().length < 3) {
      return 'الاسم قصير جداً';
    }
    return null;
  }

  /// التحقق من البريد الإلكتروني
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'صيغة بريد غير صحيحة';
    }
    return null;
  }

  /// التحقق من رقم الهاتف السوري
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    final normalized = value.replaceAll(' ', '');
    if (!_phoneRegex.hasMatch(normalized)) {
      return 'صيغة رقم هاتف غير صحيحة';
    }
    return null;
  }

  /// التحقق من كلمة المرور
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'كلمة المرور ضعيفة';
    }
    return null;
  }

  /// التحقق من حقل تسجيل الدخول (بريد أو هاتف)
  static String? loginIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف أو البريد مطلوب';
    }
    final trimmed = value.trim();
    if (trimmed.contains('@')) {
      return email(trimmed);
    }
    return phone(trimmed);
  }
}
