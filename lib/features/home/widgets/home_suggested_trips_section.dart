import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/home_provider.dart';
import 'home_trip_card.dart';

/// قسم قائمة الرحلات المقترحة
class HomeSuggestedTripsSection extends StatelessWidget {
  const HomeSuggestedTripsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'قائمة الرحلات المقترحة',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.homeTextSecondary,
            ),
          ),
          const SizedBox(height: 12),
          if (home.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.brandLightBlue,
                ),
              ),
            )
          else if (home.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Text(
                    home.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.authError),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: home.loadSuggestedTrips,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            )
          else if (home.filteredTrips.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'لا توجد رحلات متاحة حالياً',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.homeTextSecondary),
              ),
            )
          else
            ...home.filteredTrips.map(
              (trip) => HomeTripCard(trip: trip),
            ),
        ],
      ),
    );
  }
}
