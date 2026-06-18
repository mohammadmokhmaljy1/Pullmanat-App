import 'package:flutter/foundation.dart';

/// مزود حالة شاشة البداية — يدير منطق الانتقال بين الشاشتين
class SplashProvider extends ChangeNotifier {
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

  /// يُحاكي تهيئة التطبيق (فحص الجلسة، تحميل البيانات، إلخ)
  Future<void> initializeApp() async {
    if (_isInitializing || _isInitialized) return;

    _isInitializing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // محاكاة عمليات التهيئة حتى يتوفر الـ Backend
      await Future<void>.delayed(initializationDuration);
      _isInitialized = true;
    } catch (error) {
      _errorMessage = 'حدث خطأ أثناء تحميل التطبيق';
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }
}
