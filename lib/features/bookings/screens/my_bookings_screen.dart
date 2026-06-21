import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/app_bottom_nav_bar.dart';
import '../../../shared_widgets/app_nav_tab.dart';
import '../../../shared_widgets/status_bar_region.dart';
import '../../auth/providers/auth_provider.dart';
import '../../search/widgets/search_screen_header.dart';
import '../models/booking_model.dart';
import '../providers/bookings_provider.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_filter_bar.dart';

/// شاشة حجوزاتي — My bookings.png
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBookings());
  }

  Future<void> _loadBookings() async {
    final userId = context.read<AuthProvider>().currentUser?.userId;
    await context.read<BookingsProvider>().loadBookings(userId: userId);
  }

  void _goHome(BuildContext context) {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingsProvider>();
    final auth = context.watch<AuthProvider>();
    final items = bookings.filteredBookings;

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SearchScreenHeader(onBack: () => _goHome(context)),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 4, 20, 16),
                    child: Text(
                      'حجوزاتي',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.homeNavBar,
                      ),
                    ),
                  ),
                  BookingFilterBar(
                    selectedFilter: bookings.selectedFilter,
                    onFilterSelected: bookings.setFilter,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _BookingsBody(
                      isLoading: bookings.isLoading,
                      errorMessage: bookings.errorMessage,
                      isLoggedIn: auth.isAuthenticated,
                      items: items,
                      onRefresh: _loadBookings,
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const AppBottomNavBar(
              activeTab: AppNavTab.bookings,
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingsBody extends StatelessWidget {
  const _BookingsBody({
    required this.isLoading,
    required this.errorMessage,
    required this.isLoggedIn,
    required this.items,
    required this.onRefresh,
  });

  final bool isLoading;
  final String? errorMessage;
  final bool isLoggedIn;
  final List<BookingModel> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                size: 64,
                color: AppColors.homeTextSecondary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),
              const Text(
                'سجّل الدخول لعرض حجوزاتك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.homeTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.signIn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.homeNavBar,
                  foregroundColor: AppColors.white,
                ),
                child: const Text('تسجيل الدخول'),
              ),
            ],
          ),
        ),
      );
    }

    if (isLoading && items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.brandLightBlue),
      );
    }

    if (errorMessage != null && items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.authError),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onRefresh,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.event_busy_outlined,
                size: 64,
                color: AppColors.homeTextSecondary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),
              const Text(
                'لا توجد حجوزات في هذا القسم',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.homeTextSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.brandLightBlue,
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return BookingCard(booking: items[index]);
        },
      ),
    );
  }
}
