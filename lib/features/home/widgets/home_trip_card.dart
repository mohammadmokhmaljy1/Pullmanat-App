import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/trip_details/models/trip_details_args.dart';
import '../../../features/trip_details/screens/trip_details_screen.dart';
import '../models/trip_model.dart';

/// بطاقة رحلة واحدة في قائمة الرحلات المقترحة
class HomeTripCard extends StatelessWidget {
  const HomeTripCard({
    super.key,
    required this.trip,
  });

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // صورة الرحلة (placeholder)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.homeSurface,
                border: Border.all(color: AppColors.homeSurface),
              ),
              child: Icon(
                Icons.directions_bus,
                color: AppColors.brandLightBlue.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.routeDescription,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.homeTextSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    trip.formattedPrice,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.homeTextSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: AppColors.homeDetailsButton,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => openTripDetails(
                  context,
                  TripDetailsArgs(trip: trip),
                ),
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Text(
                    'التفاصيل',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
