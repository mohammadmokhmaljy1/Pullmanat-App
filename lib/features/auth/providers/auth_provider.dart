import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/storage/auth_session_storage.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// مزود المصادقة — يدير حالة المستخدم والجلسة المحلية
class AuthProvider extends ChangeNotifier {
  AuthProvider({
    AuthService? authService,
    AuthSessionStorage? sessionStorage,
  })  : _authService = authService ?? AuthService(),
        _sessionStorage = sessionStorage ?? AuthSessionStorage();

  final AuthService _authService;
  final AuthSessionStorage _sessionStorage;

  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;

  /// هل المستخدم مسجل دخول؟ — يعتمد على بيانات الجلسة المحفوظة
  bool get isAuthenticated => _currentUser != null && _currentUser!.userId > 0;

  /// تحميل الجلسة من SharedPreferences عند بدء التطبيق
  Future<void> initializeSession() async {
    _currentUser = await _sessionStorage.loadUser();
    _isInitialized = true;
    notifyListeners();
  }

  /// تسجيل الدخول وحفظ الجلسة محلياً
  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authService.login(
        identifier: identifier,
        password: password,
      );
      _currentUser = user;
      await _sessionStorage.saveUser(user);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// إنشاء حساب وحفظ الجلسة محلياً
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      _currentUser = user;
      await _sessionStorage.saveUser(user);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// تسجيل الخروج ومسح الجلسة المحلية
  Future<void> logout() async {
    _currentUser = null;
    await _sessionStorage.clear();
    notifyListeners();
  }

  /// مزامنة بيانات المستخدم بعد التحديث أو الجلب من الـ API
  Future<void> syncUser(UserModel user) async {
    _currentUser = user;
    await _sessionStorage.saveUser(user);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
