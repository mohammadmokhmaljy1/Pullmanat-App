import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/app_bottom_nav_bar.dart';
import '../../../shared_widgets/app_nav_tab.dart';
import '../models/departure_point_model.dart';
import '../providers/search_provider.dart';
import '../widgets/search_picker_field.dart';
import '../widgets/search_pickers.dart';
import '../widgets/search_screen_header.dart';

/// شاشة البحث عن رحلات — Search for flights.png
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  Future<void> _pickDate(BuildContext context) async {
    final search = context.read<SearchProvider>();
    final picked = await showDatePicker(
      context: context,
      initialDate: search.tripDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      search.setTripDate(picked);
    }
  }

  Future<void> _handleSearch(BuildContext context) async {
    final search = context.read<SearchProvider>();
    final success = await search.searchTrips();

    if (!context.mounted) return;

    if (success) {
      context.push(AppRoutes.flightList);
    } else if (search.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(search.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.homeBackground,
        body: SafeArea(
          child: Column(
            children: [
              const SearchScreenHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'البحث عن رحلات',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.homeNavBar,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SearchPickerField(
                        label: 'من :',
                        icon: Icons.location_on_outlined,
                        value: search.fromCity,
                        hint: 'من :',
                        onTap: () => SearchPickers.showCityPicker(
                          context: context,
                          title: 'اختر مدينة الانطلاق',
                          excludeCity: search.toCity,
                          onSelected: search.setFromCity,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SearchPickerField(
                        label: 'إلى :',
                        icon: Icons.location_on_outlined,
                        value: search.toCity,
                        hint: 'إلى :',
                        onTap: () => SearchPickers.showCityPicker(
                          context: context,
                          title: 'اختر مدينة الوصول',
                          excludeCity: search.fromCity,
                          onSelected: search.setToCity,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: SearchPickerField(
                              label: 'نقطة الإنطلاق:',
                              icon: Icons.flag_outlined,
                              value: search.departurePoint?.stationName,
                              hint: 'نقطة الإنطلاق:',
                              enabled: search.fromCity != null &&
                                  !search.isLoadingPoints,
                              onTap: () {
                                if (search.departurePoints.isEmpty) return;
                                SearchPickers.showDeparturePointPicker(
                                  context: context,
                                  stations: search.departurePoints
                                      .map((p) => p.stationName)
                                      .toList(),
                                  onSelected: (name) {
                                    final point = search.departurePoints
                                        .firstWhere(
                                      (p) => p.stationName == name,
                                      orElse: () => DeparturePointModel(
                                        stationId: 0,
                                        cityName: search.fromCity ?? '',
                                        stationName: name,
                                      ),
                                    );
                                    search.setDeparturePoint(point);
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SearchPickerField(
                              label: 'التاريخ :',
                              icon: Icons.calendar_today_outlined,
                              value: search.tripDate != null
                                  ? search.formatDateForDisplay(
                                      search.tripDate!,
                                    )
                                  : null,
                              hint: 'التاريخ :',
                              onTap: () => _pickDate(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: search.canSearch
                              ? () => _handleSearch(context)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.homeNavBar,
                            disabledBackgroundColor: AppColors.authDisabledButton,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'بحث',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (search.isSearching) ...[
                        const SizedBox(height: 32),
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.brandLightBlue,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(
          activeTab: AppNavTab.search,
        ),
      ),
    );
  }
}
