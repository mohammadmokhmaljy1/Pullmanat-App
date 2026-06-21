import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/models/user_model.dart';

/// تخزين جلسة المستخدم محلياً — بدون توكن، مع صلاحية 7 أيام
class AuthSessionStorage {
  AuthSessionStorage({this._prefs});

  static const String _sessionKey = 'user_session';
  static const Duration sessionDuration = Duration(days: 7);

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  /// حفظ بيانات المستخدم مع وقت الحفظ لاحتساب مدة الجلسة
  Future<void> saveUser(UserModel user) async {
    final prefs = await _preferences;
    final payload = {
      'user': user.toJson(),
      'saved_at_ms': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(_sessionKey, jsonEncode(payload));
  }

  /// استرجاع بيانات المستخدم إذا لم تنتهِ مدة الـ 7 أيام
  Future<UserModel?> loadUser() async {
    final prefs = await _preferences;
    final raw = prefs.getString(_sessionKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;

      // دعم الصيغة القديمة (user فقط بدون timestamp)
      if (map.containsKey('user_id')) {
        return UserModel.fromJson(map);
      }

      final userMap = map['user'];
      if (userMap is! Map) {
        await clear();
        return null;
      }

      final savedAtMs = map['saved_at_ms'];
      if (savedAtMs is! num || _isExpired(savedAtMs.toInt())) {
        await clear();
        return null;
      }

      return UserModel.fromJson(Map<String, dynamic>.from(userMap));
    } catch (_) {
      await clear();
      return null;
    }
  }

  /// هل توجد جلسة صالحة؟
  Future<bool> hasSession() async {
    final user = await loadUser();
    return user != null && user.userId > 0;
  }

  /// مسح الجلسة عند تسجيل الخروج أو انتهاء المدة
  Future<void> clear() async {
    final prefs = await _preferences;
    await prefs.remove(_sessionKey);
  }

  /// التحقق من انتهاء مدة الجلسة (7 أيام)
  bool _isExpired(int savedAtMs) {
    final savedAt = DateTime.fromMillisecondsSinceEpoch(savedAtMs);
    return DateTime.now().difference(savedAt) > sessionDuration;
  }
}
