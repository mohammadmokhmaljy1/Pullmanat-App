import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';

/// رأس الشاشة — زر رجوع + شعار
class SearchScreenHeader extends StatelessWidget {
  const SearchScreenHeader({
    super.key,
    this.showBackButton = true,
    this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/logo_light.png',
              height: 44,
              fit: BoxFit.contain,
            ),
            if (showBackButton)
              IconButton(
                onPressed: onBack ?? () => context.go(AppRoutes.home),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.homeTextSecondary,
                  size: 22,
                ),
              )
            else
              const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
