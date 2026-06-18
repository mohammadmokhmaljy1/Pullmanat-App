import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// شريط علوي يحتوي على زر الرجوع (اختياري) وزر التخطي
class OnboardingTopBar extends StatelessWidget {
  const OnboardingTopBar({
    super.key,
    required this.showBackButton,
    required this.onBack,
    required this.onSkip,
  });

  final bool showBackButton;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // زر الرجوع يظهر من الصفحة الثانية فقط
            SizedBox(
              width: 48,
              child: showBackButton
                  ? IconButton(
                      onPressed: onBack,
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white,
                        size: 22,
                      ),
                    )
                  : null,
            ),
            // زر تخطي مع خط سفلي كما في التصميم
            TextButton(
              onPressed: onSkip,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.white, width: 1),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Text(
                    'تخطي',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
