import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'google_icon.dart';

/// زر تسجيل الدخول عبر Google
class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white,
          side: BorderSide(color: AppColors.white.withValues(alpha: 0.6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GoogleIcon(),
            SizedBox(width: 12),
            Text(
              'تسجيل دخول باستخدام غوغل',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
