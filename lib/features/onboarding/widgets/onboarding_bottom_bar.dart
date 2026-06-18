import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/onboarding_provider.dart';
import 'onboarding_next_button.dart';
import 'onboarding_page_indicator.dart';
import 'onboarding_start_button.dart';

/// الشريط السفلي: مؤشر الصفحات + زر التالي أو "هيا نبدأ"
class OnboardingBottomBar extends StatelessWidget {
  const OnboardingBottomBar({
    super.key,
    required this.onNext,
    required this.onStart,
  });

  final VoidCallback onNext;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OnboardingPageIndicator(
            totalPages: onboarding.totalPages,
            currentPage: onboarding.currentPage,
          ),
          if (onboarding.isLastPage)
            OnboardingStartButton(onPressed: onStart)
          else
            OnboardingNextButton(onPressed: onNext),
        ],
      ),
    );
  }
}
