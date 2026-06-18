import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/splash_provider.dart';
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
    SystemChrome.setSystemUIOverlayStyle(AppTheme.splashOverlayStyle);
    _startInitialization();
  }

  /// بدء تهيئة التطبيق ثم الانتقال للشاشة الرئيسية
  Future<void> _startInitialization() async {
    final splashProvider = context.read<SplashProvider>();
    await splashProvider.initializeApp();

    if (!mounted) return;

    // بعد اكتمال التهيئة ننتقل لشاشات التعريف
    if (splashProvider.isInitialized) {
      context.go(AppRoutes.gettingStarted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Stack(
        children: [
          // الشعار في منتصف الشاشة
          const Center(
            child: SplashLogo(),
          ),
          // مؤشر التحميل في الثلث السفلي كما في التصميم
          const Align(
            alignment: Alignment(0, 0.65),
            child: SplashLoadingIndicator(),
          ),
        ],
      ),
    );
  }
}
