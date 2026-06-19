/// ترجمة رسائل الخطأ القادمة من الـ API (إنجليزي) إلى العربية
class ErrorMessageTranslator {
  ErrorMessageTranslator._();

  /// قاموس الرسائل الشائعة من الـ Backend
  static const Map<String, String> _translations = {
    'incorrect password': 'كلمة المرور غير صحيحة',
    'invalid password': 'كلمة المرور غير صحيحة',
    'wrong password': 'كلمة المرور غير صحيحة',
    'invalid credentials': 'بيانات الدخول غير صحيحة',
    'incorrect credentials': 'بيانات الدخول غير صحيحة',
    'user not found': 'المستخدم غير موجود',
    'email not found': 'البريد الإلكتروني غير مسجل',
    'invalid email': 'البريد الإلكتروني غير صالح',
    'email already exists': 'البريد الإلكتروني مستخدم مسبقاً',
    'email already registered': 'البريد الإلكتروني مستخدم مسبقاً',
    'phone already exists': 'رقم الهاتف مستخدم مسبقاً',
    'phone already registered': 'رقم الهاتف مستخدم مسبقاً',
    'invalid phone': 'رقم الهاتف غير صالح',
    'password too short': 'كلمة المرور ضعيفة',
    'weak password': 'كلمة المرور ضعيفة',
    'missing required fields': 'يرجى تعبئة جميع الحقول المطلوبة',
    'all fields are required': 'يرجى تعبئة جميع الحقول المطلوبة',
    'unauthorized': 'غير مصرح، يرجى تسجيل الدخول',
    'forbidden': 'ليس لديك صلاحية لهذا الإجراء',
    'not found': 'المورد المطلوب غير موجود',
    'internal server error': 'خطأ في الخادم، حاول لاحقاً',
    'server error': 'خطأ في الخادم، حاول لاحقاً',
    'bad request': 'طلب غير صالح',
    'registration failed': 'فشل إنشاء الحساب',
    'login failed': 'فشل تسجيل الدخول',
    'failed': 'فشلت العملية',
    'error': 'حدث خطأ',
  };

  /// ترجمة رسالة مع مراعاة رمز حالة HTTP عند الحاجة
  static String translate(String message, {int? statusCode}) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      return _fromStatusCode(statusCode) ?? 'حدث خطأ غير متوقع';
    }

    // إذا كانت الرسالة بالعربية نعيدها كما هي
    if (_containsArabic(trimmed)) return trimmed;

    final normalized = trimmed.toLowerCase();

    // مطابقة تامة
    if (_translations.containsKey(normalized)) {
      return _translations[normalized]!;
    }

    // مطابقة جزئية للرسائل المركّبة
    for (final entry in _translations.entries) {
      if (normalized.contains(entry.key)) {
        return entry.value;
      }
    }

    return _fromStatusCode(statusCode) ?? trimmed;
  }

  /// رسائل افتراضية حسب رمز HTTP — للاستخدام عند غياب رسالة من الخادم
  static String? fromStatusCode(int? statusCode) => _fromStatusCode(statusCode);

  static String? _fromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'طلب غير صالح';
      case 401:
        return 'بيانات الدخول غير صحيحة';
      case 403:
        return 'ليس لديك صلاحية لهذا الإجراء';
      case 404:
        return 'المستخدم غير موجود';
      case 409:
        return 'البيانات مستخدمة مسبقاً';
      case 422:
        return 'البيانات المدخلة غير صالحة';
      case 500:
      case 502:
      case 503:
        return 'خطأ في الخادم، حاول لاحقاً';
      default:
        return null;
    }
  }

  static bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
