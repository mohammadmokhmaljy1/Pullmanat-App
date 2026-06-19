import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_bottom_bar.dart';
import '../widgets/onboarding_page_content.dart';
import '../widgets/onboarding_top_bar.dart';

/// شاشة التعريف بالتطبيق — ثلاث صفحات قابلة للتمرير (Getting Started)
class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({super.key});

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// الانتقال لصفحة محددة مع مزامنة المزود
  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  /// عند تغيير الصفحة بالتمرير اليدوي
  void _onPageChanged(int index) {
    context.read<OnboardingProvider>().setPage(index);
  }

  /// الانتقال للصفحة التالية
  void _handleNext() {
    final onboarding = context.read<OnboardingProvider>();
    final nextIndex = onboarding.nextPageIndex;
    if (nextIndex != null) _goToPage(nextIndex);
  }

  /// الرجوع للصفحة السابقة
  void _handleBack() {
    final onboarding = context.read<OnboardingProvider>();
    final previousIndex = onboarding.previousPageIndex;
    if (previousIndex != null) _goToPage(previousIndex);
  }

  /// تخطي التعريف والانتقال لتسجيل الدخول
  void _handleSkip() {
    context.go(AppRoutes.signIn);
  }

  /// إنهاء التعريف من الصفحة الأخيرة
  void _handleStart() {
    context.go(AppRoutes.signIn);
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Column(
          children: [
            OnboardingTopBar(
              showBackButton: !onboarding.isFirstPage,
              onBack: _handleBack,
              onSkip: _handleSkip,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: OnboardingProvider.pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return OnboardingPageContent(
                    page: OnboardingProvider.pages[index],
                  );
                },
              ),
            ),
            OnboardingBottomBar(
              onNext: _handleNext,
              onStart: _handleStart,
            ),
          ],
        ),
      ),
    );
  }
}
