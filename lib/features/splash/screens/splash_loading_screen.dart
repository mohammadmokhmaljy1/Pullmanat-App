import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/splash_provider.dart';
import '../../../shared_widgets/status_bar_region.dart';
import '../widgets/splash_loading_indicator.dart';
import '../widgets/splash_logo.dart';

/// الشاشة الثانية — الشعار مع مؤشر التحميل (Splash Screen - 2)
class SplashLoadingScreen extends StatefulWidget {
  const SplashLoadingScreen({super.key});

  @override
  State<SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _startInitialization();
  }

  /// بدء التهيئة ثم التوجيه حسب الجلسة وحالة التعريف
  Future<void> _startInitialization() async {
    final splashProvider = context.read<SplashProvider>();
    final authProvider = context.read<AuthProvider>();

    final nextRoute = await splashProvider.resolveStartupRoute(
      isAuthenticated: authProvider.isAuthenticated,
    );

    if (!mounted || nextRoute == null) return;
    context.go(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarRegion.darkTop(
      child: Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Stack(
        children: [
          const Center(
            child: SplashLogo(),
          ),
          const Align(
            alignment: Alignment(0, 0.65),
            child: SplashLoadingIndicator(),
          ),
        ],
      ),
      ),
    );
  }
}
