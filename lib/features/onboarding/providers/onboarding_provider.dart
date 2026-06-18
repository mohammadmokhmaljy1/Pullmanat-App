import 'package:flutter/foundation.dart';

import '../models/onboarding_page_model.dart';

/// مزود حالة شاشات التعريف — يدير التنقل بين الصفحات
class OnboardingProvider extends ChangeNotifier {
  /// بيانات الصفحات الثلاث المطابقة لتصاميم Figma
  static const List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      imagePath: 'assets/images/onboarding_1.png',
      title: 'حجز سريع',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/onboarding_2.png',
      title: 'شركات متعددة',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/onboarding_3.png',
      title: 'رحلات بين المحافظات',
    ),
  ];

  int _currentPage = 0;

  int get currentPage => _currentPage;
  int get totalPages => pages.length;

  /// هل نحن في الصفحة الأولى؟ (لإخفاء زر الرجوع)
  bool get isFirstPage => _currentPage == 0;

  /// هل نحن في الصفحة الأخيرة؟ (لعرض زر "هيا نبدأ")
  bool get isLastPage => _currentPage == totalPages - 1;

  /// تحديث الصفحة الحالية عند التمرير
  void setPage(int index) {
    if (index == _currentPage || index < 0 || index >= totalPages) return;
    _currentPage = index;
    notifyListeners();
  }

  /// الانتقال للصفحة التالية
  int? get nextPageIndex {
    if (isLastPage) return null;
    return _currentPage + 1;
  }

  /// الرجوع للصفحة السابقة
  int? get previousPageIndex {
    if (isFirstPage) return null;
    return _currentPage - 1;
  }
}
