import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/app_bottom_nav_bar.dart';
import '../../../shared_widgets/app_nav_tab.dart';
import '../../../shared_widgets/status_bar_region.dart';
import '../providers/companies_provider.dart';
import '../widgets/company_card.dart';

/// شاشة شركات النقل — عرض جميع الشركات المسجّلة
class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompaniesProvider>().loadCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompaniesProvider>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: StatusBarRegion.darkTop(
        child: Scaffold(
        backgroundColor: AppColors.homeBackground,
        appBar: AppBar(
          backgroundColor: AppColors.homeNavBar,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'شركات النقل',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            onPressed: () => context.go(AppRoutes.home),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
        ),
        body: RefreshIndicator(
          color: AppColors.brandLightBlue,
          onRefresh: provider.loadCompanies,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: _IntroBanner(
                    count: provider.companies.length,
                    isLoading: provider.isLoading,
                  ),
                ),
              ),
              if (provider.isLoading && provider.companies.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.brandLightBlue,
                    ),
                  ),
                )
              else if (provider.companies.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final company = provider.sortedCompanies[index];
                        return CompanyCard(company: company);
                      },
                      childCount: provider.sortedCompanies.length,
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
    );
  }
}

/// بانر تعريفي أعلى القائمة
class _IntroBanner extends StatelessWidget {
  const _IntroBanner({
    required this.count,
    required this.isLoading,
  });

  final int count;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.homeNavBar,
            AppColors.homeNavBar.withValues(alpha: 0.85),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.business_rounded,
              color: AppColors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'شركات متعددة',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLoading
                      ? 'جاري تحميل الشركات...'
                      : 'تصفح $count شركة نقل مسجّلة في التطبيق',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.business_outlined,
              size: 64,
              color: AppColors.homeTextSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد شركات متاحة حالياً',
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
}
