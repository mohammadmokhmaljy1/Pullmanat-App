import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';

/// قائمة إعدادات الملف الشخصي — مساعدة، خصوصية، شروط
class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  static const _items = [
    (Icons.help_outline_rounded, 'احصل على المساعدة', AppRoutes.profileHelp),
    (Icons.shield_outlined, 'سياسة الخصوصية', AppRoutes.profilePrivacy),
    (Icons.description_outlined, 'الأحكام والشروط', AppRoutes.profileTerms),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.homeSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isLast = index == _items.length - 1;

            return Column(
              children: [
                ListTile(
                  onTap: () => context.push(item.$3),
                  leading: Icon(
                    item.$1,
                    color: AppColors.authPrimaryButton,
                  ),
                  title: Text(
                    item.$2,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A2F3D),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.homeTextSecondary.withValues(alpha: 0.7),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 56,
                    endIndent: 16,
                    color: AppColors.white.withValues(alpha: 0.6),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
