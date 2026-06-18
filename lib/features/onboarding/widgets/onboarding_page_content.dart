import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/onboarding_page_model.dart';

/// محتوى صفحة واحدة: صورة التوضيح + العنوان
class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    super.key,
    required this.page,
  });

  final OnboardingPageModel page;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // صورة الهاتف داخل إطار مستدير كما في Figma
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                page.imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          page.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
