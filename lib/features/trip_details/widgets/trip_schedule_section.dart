import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/trip_schedule_info.dart';

/// قائمة أوقات الرحلة — انطلاق، استراحة، وصول
class TripScheduleSection extends StatelessWidget {
  const TripScheduleSection({
    super.key,
    required this.schedule,
    this.nationalId,
  });

  final TripScheduleInfo schedule;
  final String? nationalId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ScheduleRow(label: 'الانطلاق :', value: schedule.departure),
          const SizedBox(height: 10),
          _ScheduleRow(label: 'استراحة :', value: schedule.breakTime),
          const SizedBox(height: 10),
          _ScheduleRow(label: 'الوصول :', value: schedule.arrival),
          if (nationalId != null) ...[
            const SizedBox(height: 10),
            _ScheduleRow(label: 'الرقم الوطني :', value: nationalId!),
          ],
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.homeNavBar,
          height: 1.4,
        ),
        children: [
          TextSpan(text: '$label '),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

/// عرض السعر بخط أخضر
class TripPriceSection extends StatelessWidget {
  const TripPriceSection({super.key, required this.price});

  final double price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
      child: Align(
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.homeNavBar,
            ),
            children: [
              const TextSpan(text: 'السعر : '),
              TextSpan(
                text: '${price.toStringAsFixed(0)} ل.س',
                style: const TextStyle(
                  color: AppColors.profileSaveButton,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
