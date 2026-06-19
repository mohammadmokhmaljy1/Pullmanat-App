import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// صف العنوان ورسالة الخطأ — ترتيب RTL: العنوان يمين والخطأ يسار
class AuthFieldLabelRow extends StatelessWidget {
  const AuthFieldLabelRow({
    super.key,
    required this.label,
    this.errorText,
  });

  final String label;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (errorText != null)
              Flexible(
                child: Text(
                  errorText!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: AppColors.authError,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
