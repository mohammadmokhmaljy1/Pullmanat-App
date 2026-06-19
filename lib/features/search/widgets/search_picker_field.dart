import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// حقل إدخال في نموذج البحث — قابل للنقر مع أيقونة
class SearchPickerField extends StatelessWidget {
  const SearchPickerField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.hint,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final String? value;
  final String hint;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final displayText = (value != null && value!.isNotEmpty) ? value! : hint;
    final isPlaceholder = value == null || value!.isEmpty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.brandLightBlue.withValues(alpha: 0.6),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isPlaceholder ? hint : displayText,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      color: isPlaceholder
                          ? AppColors.homeTextSecondary.withValues(alpha: 0.7)
                          : AppColors.homeTextSecondary,
                      fontWeight:
                          isPlaceholder ? FontWeight.normal : FontWeight.w500,
                    ),
                  ),
                ),
                Icon(icon, color: AppColors.brandLightBlue, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
