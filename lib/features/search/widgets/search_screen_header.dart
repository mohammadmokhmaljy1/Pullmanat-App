import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// رأس الشاشة — زر رجوع + شعار
class SearchScreenHeader extends StatelessWidget {
  const SearchScreenHeader({
    super.key,
    this.showBackButton = false,
    this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton)
            IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.homeTextSecondary,
              ),
            )
          else
            const SizedBox(width: 48),
          Image.asset(
            'assets/images/logo_light.png',
            height: 44,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
