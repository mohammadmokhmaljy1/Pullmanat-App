import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/splash_provider.dart';
import '../widgets/splash_logo.dart';

/// الشاشة الأولى — عرض الشعار فقط (Splash Screen)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLoadingScreen();
  }

  /// بعد انتهاء مدة العرض، ننتقل لشاشة التحميل
  Future<void> _navigateToLoadingScreen() async {
    final splashProvider = context.read<SplashProvider>();
    await splashProvider.waitForSplashDisplay();

    if (!mounted) return;
    context.go(AppRoutes.splashLoading);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: SplashLogo(),
      ),
    );
  }
}
