import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/providers/home_provider.dart';
import 'features/onboarding/providers/onboarding_provider.dart';
import 'features/search/providers/search_provider.dart';
import 'features/splash/providers/splash_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(AppTheme.statusBarStyle);
  runApp(const PullmanatApp());
}

/// نقطة الدخول الرئيسية للتطبيق
class PullmanatApp extends StatelessWidget {
  const PullmanatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MaterialApp.router(
        title: 'بين المدن',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          SystemChrome.setSystemUIOverlayStyle(AppTheme.statusBarStyle);
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
