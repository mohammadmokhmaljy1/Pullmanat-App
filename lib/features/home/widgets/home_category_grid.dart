import 'package:flutter/material.dart';

import '../../../shared_widgets/coming_soon_dialog.dart';
import 'home_category_card.dart';

/// شبكة الفئات الأربع في أعلى الشاشة الرئيسية
class HomeCategoryGrid extends StatelessWidget {
  const HomeCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.35,
        children: [
          HomeCategoryCard(
            icon: Icons.directions_bus_outlined,
            label: 'رحلات مخصصة',
            onTap: () => ComingSoonDialog.show(context),
          ),
          HomeCategoryCard(
            icon: Icons.confirmation_number_outlined,
            label: 'حجز سريع',
            onTap: () => ComingSoonDialog.show(context),
          ),
          HomeCategoryCard(
            icon: Icons.flag_outlined,
            label: 'نقاط الانطلاق',
            onTap: () => ComingSoonDialog.show(context),
          ),
          HomeCategoryCard(
            icon: Icons.business_outlined,
            label: 'شركات متعددة',
            onTap: () => ComingSoonDialog.show(context),
          ),
        ],
      ),
    );
  }
}
