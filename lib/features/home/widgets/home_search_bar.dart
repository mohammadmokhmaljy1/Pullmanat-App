import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// شريط البحث عن رحلة
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          onChanged: onChanged,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: 'بحث عن رحلة..',
            hintStyle: TextStyle(
              color: AppColors.homeTextSecondary.withValues(alpha: 0.7),
            ),
            // في RTL يظهر suffixIcon على اليسار — مطابق لتصميم Figma
            suffixIcon: Icon(
              Icons.search,
              color: AppColors.homeTextSecondary.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: AppColors.homeSurface,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
