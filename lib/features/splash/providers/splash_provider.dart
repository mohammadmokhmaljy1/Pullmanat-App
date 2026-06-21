import 'package:flutter/foundation.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/storage/onboarding_storage.dart';

/// مزود حالة شاشة البداية — يدير منطق الانتقال بعد التهيئة
class SplashProvider extends ChangeNotifier {
  SplashProvider({OnboardingStorage? onboardingStorage})
      : _onboardingStorage = onboardingStorage ?? OnboardingStorage();

  final OnboardingStorage _onboardingStorage;

  /// مدة عرض الشاشة الأولى (الثابتة) قبل الانتقال لشاشة التحميل
  static const Duration splashDisplayDuration = Duration(milliseconds: 1500);

  /// مدة محاكاة تهيئة التطبيق في شاشة التحميل
  static const Duration initializationDuration = Duration(milliseconds: 2500);

  bool _isInitializing = false;
  bool _isInitialized = false;
  String? _errorMessage;

  bool get isInitializing => _isInitializing;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;

  /// ينتظر المدة المحددة لعرض الشعار ثم ينتقل للشاشة التالية
  Future<void> waitForSplashDisplay() async {
    await Future<void>.delayed(splashDisplayDuration);
  }

  /// تهيئة التApp وتحديد الشاشة التالية حسب الجلسة وحالة التعريف
  Future<String?> resolveStartupRoute({required bool isAuthenticated}) async {
    if (_isInitializing) return null;

    _isInitializing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future<void>.delayed(initializationDuration);

      final onboardingCompleted = await _onboardingStorage.isCompleted();

      // أولوية: جلسة صالحة → الرئيسية
      if (isAuthenticated) {
        _isInitialized = true;
        return AppRoutes.home;
      }

      // أول تشغيل → شاشات التعريف
      if (!onboardingCompleted) {
        _isInitialized = true;
        return AppRoutes.gettingStarted;
      }

      // عاد المستخدم بدون جلسة → تسجيل الدخول
      _isInitialized = true;
      return AppRoutes.signIn;
    } catch (error) {
      _errorMessage = 'حدث خطأ أثناء تحميل التطبيق';
      return null;
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }
}
