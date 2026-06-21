import 'package:shared_preferences/shared_preferences.dart';

/// تخزين حالة شاشات التعريف — تُعرض مرة واحدة فقط عند أول تشغيل
class OnboardingStorage {
  OnboardingStorage({this._prefs});

  static const String _completedKey = 'onboarding_completed';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  /// هل أنهى المستخدم شاشات التعريف سابقاً؟
  Future<bool> isCompleted() async {
    final prefs = await _preferences;
    return prefs.getBool(_completedKey) ?? false;
  }

  /// تعليم التعريف كمكتمل بعد Skip أو "هيا نبدأ"
  Future<void> markCompleted() async {
    final prefs = await _preferences;
    await prefs.setBool(_completedKey, true);
  }
}
