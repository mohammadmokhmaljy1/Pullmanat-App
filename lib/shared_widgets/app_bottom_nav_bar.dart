import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/routing/app_routes.dart';
import '../core/theme/app_colors.dart';
import 'app_nav_tab.dart';

/// شريط التنقل السفلي المشترك — ترتيب RTL
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.activeTab,
  });

  final AppNavTab activeTab;

  static const _tabs = [
    (AppNavTab.home, Icons.home_rounded, 'الرئيسية'),
    (AppNavTab.search, Icons.search, 'بحث'),
    (AppNavTab.bookings, Icons.confirmation_number_outlined, 'حجوزاتي'),
    (AppNavTab.profile, Icons.person_outline, 'مستخدم'),
  ];

  void _onTap(BuildContext context, AppNavTab tab) {
    if (tab == activeTab) return;

    switch (tab) {
      case AppNavTab.home:
        context.go(AppRoutes.home);
      case AppNavTab.search:
        context.go(AppRoutes.search);
      case AppNavTab.bookings:
        context.go(AppRoutes.bookings);
      case AppNavTab.profile:
        context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.homeNavBar,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _tabs.map((tab) {
            final isActive = tab.$1 == activeTab;
            return Expanded(
              child: InkWell(
                onTap: () => _onTap(context, tab.$1),
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab.$2,
                      color: isActive
                          ? AppColors.brandLightBlue
                          : AppColors.white.withValues(alpha: 0.7),
                      size: 26,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tab.$3,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                        color: isActive
                            ? AppColors.brandLightBlue
                            : AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
