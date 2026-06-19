import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/app_bottom_nav_bar.dart';
import '../../../shared_widgets/app_nav_tab.dart';
import '../providers/home_provider.dart';
import '../widgets/home_category_grid.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_suggested_trips_section.dart';

/// الشاشة الرئيسية — home.png
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل الرحلات من الـ API عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadSuggestedTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.homeBackground,
        body: SafeArea(
          child: Column(
            children: [
              const HomeHeader(),
              HomeSearchBar(
                onChanged: context.read<HomeProvider>().updateSearchQuery,
              ),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.brandLightBlue,
                  onRefresh: context.read<HomeProvider>().loadSuggestedTrips,
                  child: const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HomeCategoryGrid(),
                        HomeSuggestedTripsSection(),
                      ],
                    ),
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
    );
  }
}
