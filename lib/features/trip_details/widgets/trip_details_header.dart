import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/syrian_cities.dart';
import '../../home/models/trip_model.dart';

/// رأس شاشة تفاصيل الرحلة
class TripDetailsHeader extends StatelessWidget {
  const TripDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo_light.png',
            height: 44,
            fit: BoxFit.contain,
          ),
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.homeNavBar,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

/// قسم المسار — من → إلى
class TripRouteSection extends StatelessWidget {
  const TripRouteSection({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final from = SyrianCities.toDisplayName(trip.departureCity);
    final to = SyrianCities.toDisplayName(trip.destinationCity);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'من $from',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.homeNavBar,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.homeNavBar.withValues(alpha: 0.85),
              size: 28,
            ),
          ),
          Text(
            'الى $to',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.homeNavBar,
            ),
          ),
        ],
      ),
    );
  }
}

/// شارة LUXURY مع أيقونة الحافلة
class TripLuxuryBadge extends StatelessWidget {
  const TripLuxuryBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.homeSurface,
              border: Border.all(
                color: AppColors.brandLightBlue.withValues(alpha: 0.35),
              ),
            ),
            child: Icon(
              Icons.directions_bus_rounded,
              color: AppColors.brandLightBlue.withValues(alpha: 0.9),
              size: 26,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.brandLightBlue.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.airport_shuttle_rounded,
              color: AppColors.brandLightBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'LUXURY',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.brandLightBlue.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
