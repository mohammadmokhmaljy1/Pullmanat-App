import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// زر التالي الدائري في الصفحات الأولى والثانية
class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.onboardingNextButton,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 64,
          height: 64,
          child: Icon(
            Icons.arrow_forward_rounded,
            color: Colors.black87,
            size: 28,
          ),
        ),
      ),
    );
  }
}
