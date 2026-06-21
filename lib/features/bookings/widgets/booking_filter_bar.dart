import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/booking_filter.dart';

/// شريط فلاتر الحجوزات — الكل، القادمة، الملغاة، المكتملة
class BookingFilterBar extends StatelessWidget {
  const BookingFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final BookingFilter selectedFilter;
  final ValueChanged<BookingFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: BookingFilter.values.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Material(
              color: isSelected
                  ? AppColors.homeNavBar
                  : AppColors.homeSurface,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: () => onFilterSelected(filter),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  child: Text(
                    filter.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.homeNavBar,
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
