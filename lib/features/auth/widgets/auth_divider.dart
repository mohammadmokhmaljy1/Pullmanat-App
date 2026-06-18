import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// فاصل "أو عن طريق" بين الأزرار
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.4),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'أو عن طريق',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
