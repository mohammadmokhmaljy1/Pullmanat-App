import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/coming_soon_dialog.dart';

/// أزرار الوصول السريع — المفضلة، الدفع، الإشعارات
class ProfileQuickActions extends StatelessWidget {
  const ProfileQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    const actions = [
      (Icons.favorite_border_rounded, 'المفضلة'),
      (Icons.payments_outlined, 'طريقة الدفع'),
      (Icons.notifications_none_rounded, 'الاشعارات'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Row(
        children: actions.map((action) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Material(
                color: AppColors.homeSurface,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () => ComingSoonDialog.show(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          action.$1,
                          color: AppColors.authPrimaryButton,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          action.$2,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A2F3D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
