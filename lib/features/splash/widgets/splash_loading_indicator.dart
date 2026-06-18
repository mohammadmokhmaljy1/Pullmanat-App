import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// مؤشر التحميل الدائري كما في تصميم Splash Screen - 2
class SplashLoadingIndicator extends StatelessWidget {
  const SplashLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: CircularProgressIndicator(
        strokeWidth: 4,
        // لون الخلفية الداكن للحلقة يعطي تأثير التدرج في التصميم
        backgroundColor: AppColors.splashBackground.withValues(alpha: 0.4),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandLightBlue),
      ),
    );
  }
}
