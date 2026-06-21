import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/app_bottom_nav_bar.dart';
import '../../../shared_widgets/app_nav_tab.dart';
import '../../../shared_widgets/coming_soon_dialog.dart';
import '../../../shared_widgets/status_bar_region.dart';
import '../providers/search_provider.dart';
import '../widgets/flight_list_trip_card.dart';
import '../widgets/search_screen_header.dart';

/// شاشة نتائج البحث — Flight list.png
class FlightListScreen extends StatelessWidget {
  const FlightListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();
    final trips = search.searchResults;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: StatusBarRegion.lightTop(
        child: Scaffold(
        backgroundColor: AppColors.homeBackground,
        body: SafeArea(
          child: Column(
            children: [
              SearchScreenHeader(
                showBackButton: true,
                onBack: () => Navigator.of(context).pop(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'قائمة الرحلات',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.homeNavBar,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: AppColors.brandLightBlue,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: Text(
                                'الكل',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => ComingSoonDialog.show(context),
                          child: Row(
                            children: [
                              const Text(
                                'ترتيب حسب',
                                style: TextStyle(
                                  color: AppColors.homeNavBar,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.homeNavBar.withValues(alpha: 0.8),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: trips.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد رحلات مطابقة للبحث',
                          style: TextStyle(color: AppColors.homeTextSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          return FlightListTripCard(trip: trips[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(
          activeTab: AppNavTab.search,
        ),
        ),
      ),
    );
  }
}
