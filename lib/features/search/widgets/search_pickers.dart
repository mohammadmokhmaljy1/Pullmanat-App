import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/syrian_cities.dart';

/// نوافذ اختيار المدينة ونقطة الانطلاق — تصميم احترافي متوافق مع ثيم التطبيق
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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _PickerSheet(
          title: title,
          child: _CityList(
            cities: cities,
            onSelected: (city) {
              onSelected(city);
              Navigator.pop(sheetContext);
            },
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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _PickerSheet(
          title: 'اختر نقطة الانطلاق',
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: stations.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final station = stations[index];
              return _PickerCard(
                title: station,
                icon: Icons.flag_outlined,
                onTap: () {
                  onSelected(station);
                  Navigator.pop(sheetContext);
                },
              );
            },
          ),
        );
      },
    );
  }
}

/// حاوية مشتركة للقوائم المنبثقة
class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: const BoxDecoration(
          color: AppColors.homeBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.homeTextSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.homeNavBar,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.homeTextSecondary,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.homeSurface),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

/// قائمة المدن مع حقل بحث
class _CityList extends StatefulWidget {
  const _CityList({
    required this.cities,
    required this.onSelected,
  });

  final List<String> cities;
  final ValueChanged<String> onSelected;

  @override
  State<_CityList> createState() => _CityListState();
}

class _CityListState extends State<_CityList> {
  String _query = '';

  List<String> get _filtered {
    if (_query.trim().isEmpty) return widget.cities;
    return widget.cities
        .where((city) => city.contains(_query.trim()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            onChanged: (value) => setState(() => _query = value),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'ابحث عن مدينة...',
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.homeTextSecondary.withValues(alpha: 0.6),
              ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: _filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final city = _filtered[index];
              return _PickerCard(
                title: city,
                icon: Icons.location_on_outlined,
                onTap: () => widget.onSelected(city),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// بطاقة عنصر واحد في القائمة
class _PickerCard extends StatelessWidget {
  const _PickerCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.brandLightBlue.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.brandLightBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.brandLightBlue, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.homeNavBar,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.homeTextSecondary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
