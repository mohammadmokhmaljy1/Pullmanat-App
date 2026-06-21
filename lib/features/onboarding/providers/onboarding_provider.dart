import 'package:flutter/foundation.dart';

import '../../../core/storage/onboarding_storage.dart';
import '../models/onboarding_page_model.dart';

/// مزود حالة شاشات التعريف — يدير التنقل بين الصفحات
class OnboardingProvider extends ChangeNotifier {
  OnboardingProvider({OnboardingStorage? storage})
      : _storage = storage ?? OnboardingStorage();

  final OnboardingStorage _storage;

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
  bool get isFirstPage => _currentPage == 0;
  bool get isLastPage => _currentPage == totalPages - 1;

  void setPage(int index) {
    if (index == _currentPage || index < 0 || index >= totalPages) return;
    _currentPage = index;
    notifyListeners();
  }

  int? get nextPageIndex {
    if (isLastPage) return null;
    return _currentPage + 1;
  }

  int? get previousPageIndex {
    if (isFirstPage) return null;
    return _currentPage - 1;
  }

  /// تعليم التعريف كمكتمل — لا يُعرض مرة أخرى
  Future<void> markOnboardingCompleted() async {
    await _storage.markCompleted();
  }

  Future<bool> isOnboardingCompleted() async {
    return _storage.isCompleted();
  }
}
