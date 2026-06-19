import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/syrian_cities.dart';

/// نوافذ اختيار المدينة ونقطة الانطلاق
class SearchPickers {
  SearchPickers._();

  static Future<void> showCityPicker({
    required BuildContext context,
    required String title,
    required ValueChanged<String> onSelected,
    String? excludeCity,
  }) {
    final cities =
        SyrianCities.all.where((city) => city != excludeCity).toList();

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.homeNavBar,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return ListTile(
                      title: Text(city, textAlign: TextAlign.right),
                      onTap: () {
                        onSelected(city);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showDeparturePointPicker({
    required BuildContext context,
    required List<String> stations,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'اختر نقطة الانطلاق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.homeNavBar,
                  ),
                ),
              ),
              ...stations.map(
                (station) => ListTile(
                  title: Text(station, textAlign: TextAlign.right),
                  onTap: () {
                    onSelected(station);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
