import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/app_bottom_nav_bar.dart';
import '../../../shared_widgets/app_nav_tab.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared_widgets/status_bar_region.dart';
import '../providers/profile_provider.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/profile_hero_section.dart';
import '../widgets/profile_logout_button.dart';
import '../widgets/profile_menu_list.dart';
import '../widgets/profile_quick_actions.dart';

/// شاشة حسابي — My Account
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  /// التحقق من الجلسة ثم جلب أحدث بيانات المستخدم
  Future<void> _bootstrap() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) {
      if (mounted) context.go(AppRoutes.signIn);
      return;
    }

    await _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    final auth = context.read<AuthProvider>();
    final profile = context.read<ProfileProvider>();
    final userId = auth.currentUser?.userId;
    if (userId == null) return;

    final user = await profile.fetchProfile(userId: userId);
    if (user != null && mounted) {
      final current = auth.currentUser;
      final merged = user.email.isEmpty && current != null
          ? user.copyWith(email: current.email)
          : user;
      await auth.syncUser(merged);
    }
  }

  bool _isLoggingOut = false;

  /// تسجيل الخروج ومسح الجلسة ثم التوجيه لشاشة الدخول
  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل تريد تسجيل الخروج من حسابك؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'خروج',
                style: TextStyle(color: AppColors.bookingCancelled),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoggingOut = true);
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    context.go(AppRoutes.signIn);
  }

  void _openEditDialog() {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;

    EditProfileDialog.show(
      context,
      user: user,
      onSaved: (updatedUser) async {
        await context.read<AuthProvider>().syncUser(updatedUser);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث البيانات بنجاح'),
              backgroundColor: AppColors.profileSaveButton,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profile = context.watch<ProfileProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return StatusBarRegion.lightTop(
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppColors.brandLightBlue),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: StatusBarRegion.darkTop(
        child: Scaffold(
        backgroundColor: AppColors.homeBackground,
        body: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.brandLightBlue,
              onRefresh: _refreshProfile,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: ProfileHeroSection(
                      user: user,
                      onEditPressed: _openEditDialog,
                      onLogout: _handleLogout,
                    ),
                  ),
                  const SliverToBoxAdapter(child: ProfileQuickActions()),
                  const SliverToBoxAdapter(child: ProfileMenuList()),
                  SliverToBoxAdapter(
                    child: ProfileLogoutButton(
                      isLoading: _isLoggingOut,
                      onPressed: _handleLogout,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
            if (profile.isLoadingProfile)
              SafeArea(
                bottom: false,
                child: LinearProgressIndicator(
                  minHeight: 3,
                  color: AppColors.brandLightBlue,
                  backgroundColor: Colors.transparent,
                ),
              ),
          ],
        ),
        bottomNavigationBar: const AppBottomNavBar(
          activeTab: AppNavTab.profile,
        ),
        ),
      ),
    );
  }
}
