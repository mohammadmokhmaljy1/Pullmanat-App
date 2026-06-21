import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';

/// حقل نصي في نموذج طلب الرحلة المخصصة
class CustomTripFormField extends StatelessWidget {
  const CustomTripFormField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLines = 1,
    this.textDirection = TextDirection.rtl,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final String? hint;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final TextDirection textDirection;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textAlign =
        textDirection == TextDirection.ltr ? TextAlign.left : TextAlign.right;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.brandLightBlue.withValues(alpha: 0.6),
          ),
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          textAlign: textAlign,
          textDirection: textDirection,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.homeTextSecondary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint ?? label,
            hintTextDirection: textDirection,
            hintStyle: TextStyle(
              color: AppColors.homeTextSecondary.withValues(alpha: 0.7),
              fontWeight: FontWeight.normal,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: maxLines > 1 ? 16 : 14,
            ),
            border: InputBorder.none,
            suffixIcon: icon != null
                ? Icon(icon, color: AppColors.brandLightBlue, size: 22)
                : null,
          ),
        ),
      ),
    );
  }
}
