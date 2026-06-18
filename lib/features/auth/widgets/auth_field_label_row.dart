import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// صف العنوان ورسالة الخطأ — العنوان يمين والخطأ يسار كما في Figma
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (errorText != null)
            Expanded(
              child: Text(
                errorText!,
                style: const TextStyle(
                  color: AppColors.authError,
                  fontSize: 13,
                ),
                textAlign: TextAlign.left,
              ),
            )
          else
            const Spacer(),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
