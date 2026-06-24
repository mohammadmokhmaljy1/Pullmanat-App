import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/app_bottom_nav_bar.dart';
import '../../../shared_widgets/app_nav_tab.dart';
import '../../../shared_widgets/status_bar_region.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/trip_details_args.dart';
import '../models/trip_schedule_info.dart';
import '../providers/trip_details_provider.dart';
import '../widgets/trip_details_dialogs.dart';
import '../widgets/trip_details_footer.dart';
import '../widgets/trip_details_header.dart';
import '../widgets/trip_schedule_section.dart';

/// شاشة تفاصيل الرحلة — Trip details.png / Trip details1.png
class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key, required this.args});

  final TripDetailsArgs args;

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TripDetailsProvider>();
      provider.init(widget.args);
      final userId = context.read<AuthProvider>().currentUser?.userId;
      provider.loadActiveBooking(userId: userId);
    });
  }

  Future<void> _handleBook(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) {
      context.go(AppRoutes.signIn);
      return;
    }

    final nationalId = await BookTripDialog.show(context);
    if (!context.mounted || nationalId == null) return;

    final provider = context.read<TripDetailsProvider>();
    final success = await provider.bookTrip(
      userId: auth.currentUser!.userId,
      nationalId: nationalId,
    );

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم الحجز بنجاح'),
          backgroundColor: AppColors.profileSaveButton,
        ),
      );
    } else if (provider.errorMessage != null) {
      _showError(context, provider.errorMessage!);
    }
  }

  Future<void> _handleCancel(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تأكيد الإلغاء'),
          content: const Text('هل تريد إلغاء هذا الحجز؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('لا'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'نعم، إلغاء',
                style: TextStyle(color: AppColors.bookingCancelled),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final provider = context.read<TripDetailsProvider>();
    final success = await provider.cancelBooking();

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إلغاء الحجز')),
      );
    } else if (provider.errorMessage != null) {
      _showError(context, provider.errorMessage!);
    }
  }

  Future<void> _handleEdit(BuildContext context) async {
    final provider = context.read<TripDetailsProvider>();
    final booking = provider.activeBooking;
    if (booking == null) return;

    final result = await EditBookingDialog.show(
      context,
      initialNationalId: booking.nationalId ?? 0,
      initialNotes: booking.notes ?? '',
    );

    if (!context.mounted || result == null) return;

    final success = await provider.updateBooking(
      nationalId: result.nationalId,
      notes: result.notes,
    );

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث الحجز')),
      );
    } else if (provider.errorMessage != null) {
      _showError(context, provider.errorMessage!);
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.authError,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TripDetailsProvider>();
    final trip = provider.trip ?? widget.args.trip;

    if (provider.isLoading && !provider.isRegistered) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: StatusBarRegion.lightTop(
          child: Scaffold(
            backgroundColor: AppColors.homeBackground,
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.brandLightBlue),
            ),
          ),
        ),
      );
    }

    final schedule = TripScheduleInfo.fromTrip(trip);
    final booking = provider.activeBooking;
    final nationalId = booking?.nationalId?.toString();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: StatusBarRegion.lightTop(
        child: Scaffold(
          backgroundColor: AppColors.homeBackground,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TripDetailsHeader(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Text(
                    'تفاصيل الرحلة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.homeNavBar,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TripRouteSection(trip: trip),
                        const TripLuxuryBadge(),
                        TripScheduleSection(
                          schedule: schedule,
                          nationalId:
                              provider.isRegistered ? nationalId : null,
                        ),
                        TripPriceSection(price: trip.tripPrice),
                        if (provider.isRegistered)
                          TripRegisteredActions(
                            isSubmitting: provider.isSubmitting,
                            onCancel: () => _handleCancel(context),
                            onEdit: () => _handleEdit(context),
                          ),
                      ],
                    ),
                  ),
                ),
                if (!provider.isRegistered)
                  TripBookingFooter(
                    isSubmitting: provider.isSubmitting,
                    onBook: () => _handleBook(context),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: const AppBottomNavBar(
            activeTab: AppNavTab.home,
          ),
        ),
      ),
    );
  }
}

/// مساعد للتنقل إلى شاشة التفاصيل
void openTripDetails(BuildContext context, TripDetailsArgs args) {
  context.push(AppRoutes.tripDetails, extra: args);
}
