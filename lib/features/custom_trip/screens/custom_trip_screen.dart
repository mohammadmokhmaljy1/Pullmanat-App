import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/app_bottom_nav_bar.dart';
import '../../../shared_widgets/app_nav_tab.dart';
import '../../../shared_widgets/status_bar_region.dart';
import '../../auth/providers/auth_provider.dart';
import '../../search/widgets/search_picker_field.dart';
import '../../search/widgets/search_pickers.dart';
import '../../search/widgets/search_screen_header.dart';
import '../providers/custom_trip_provider.dart';
import '../widgets/custom_trip_form_field.dart';

/// شاشة طلب رحلة معينة — A specific trip.png
class CustomTripScreen extends StatefulWidget {
  const CustomTripScreen({super.key});

  @override
  State<CustomTripScreen> createState() => _CustomTripScreenState();
}

class _CustomTripScreenState extends State<CustomTripScreen> {
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _goHome(BuildContext context) {
    context.go(AppRoutes.home);
  }

  /// اختيار التاريخ المفضل للرحلة
  Future<void> _pickPreferredDate(BuildContext context) async {
    final provider = context.read<CustomTripProvider>();
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: provider.preferredDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (!context.mounted || pickedDate == null) return;

    provider.setPreferredDate(pickedDate);
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final provider = context.read<CustomTripProvider>();
    final userId = context.read<AuthProvider>().currentUser?.userId;

    provider.clearError();
    final success = await provider.submitRequest(userId: userId);

    if (!context.mounted) return;

    if (success) {
      _timeController.clear();
      _notesController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال طلبك بنجاح، سنتواصل معك قريباً'),
          backgroundColor: AppColors.profileSaveButton,
        ),
      );
      return;
    }

    if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage!),
          backgroundColor: AppColors.authError,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomTripProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goHome(context);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: StatusBarRegion.lightTop(
          child: Scaffold(
            backgroundColor: AppColors.homeBackground,
            body: SafeArea(
              child: Column(
                children: [
                  SearchScreenHeader(onBack: () => _goHome(context)),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'طلب رحلة معينة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.homeNavBar,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'أرسل تفاصيل رحلتك وسنجد لك أفضل خيار متاح',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: AppColors.homeTextSecondary
                                  .withValues(alpha: 0.85),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SearchPickerField(
                            label: 'من :',
                            icon: Icons.location_on_outlined,
                            value: provider.fromCity,
                            hint: 'من :',
                            onTap: () => SearchPickers.showCityPicker(
                              context: context,
                              title: 'اختر مدينة الانطلاق',
                              excludeCity: provider.toCity,
                              onSelected: provider.setFromCity,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SearchPickerField(
                            label: 'إلى :',
                            icon: Icons.location_on_outlined,
                            value: provider.toCity,
                            hint: 'إلى :',
                            onTap: () => SearchPickers.showCityPicker(
                              context: context,
                              title: 'اختر مدينة الوصول',
                              excludeCity: provider.fromCity,
                              onSelected: provider.setToCity,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SearchPickerField(
                            label: 'التاريخ المفضل:',
                            icon: Icons.calendar_today_outlined,
                            value: provider.preferredDate != null
                                ? provider.formatDateForDisplay(
                                    provider.preferredDate!,
                                  )
                                : null,
                            hint: 'التاريخ المفضل:',
                            onTap: () => _pickPreferredDate(context),
                          ),
                          const SizedBox(height: 12),
                          CustomTripFormField(
                            label: 'التوقيت المناسب:',
                            hint: '14:30',
                            icon: Icons.access_time_rounded,
                            controller: _timeController,
                            keyboardType: TextInputType.datetime,
                            textDirection: TextDirection.ltr,
                            onChanged: provider.setPreferredTime,
                          ),
                          const SizedBox(height: 12),
                          CustomTripFormField(
                            label: 'ملاحظات إضافية',
                            hint: 'ملاحظات إضافية',
                            controller: _notesController,
                            maxLines: 4,
                            onChanged: provider.setNotes,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: provider.canSubmit
                                  ? () => _handleSubmit(context)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.homeNavBar,
                                disabledBackgroundColor:
                                    AppColors.authDisabledButton,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: provider.isSubmitting
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : const Text(
                                      'إرسال طلب',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const AppBottomNavBar(
              activeTab: AppNavTab.home,
            ),
          ),
        ),
      ),
    );
  }
}
