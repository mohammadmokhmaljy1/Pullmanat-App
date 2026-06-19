import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// نافذة منبثقة تُعرض عند الضغط على ميزات غير مفعّلة بعد
class ComingSoonDialog {
  ComingSoonDialog._();

  /// عرض رسالة "سيتم تفعيل هذه الميزة لاحقاً"
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppColors.authBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: const Text(
              'سيتم تفعيل هذه الميزة لاحقاً',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'حسناً',
                  style: TextStyle(
                    color: AppColors.brandLightBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
