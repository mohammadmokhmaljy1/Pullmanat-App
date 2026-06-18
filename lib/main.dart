import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/providers/splash_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PullmanatApp());
}

/// نقطة الدخول الرئيسية للتطبيق
class PullmanatApp extends StatelessWidget {
  const PullmanatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // مزود شاشة البداية — يُستخدم لإدارة منطق الانتقال والتهيئة
        ChangeNotifierProvider(create: (_) => SplashProvider()),
      ],
      child: MaterialApp.router(
        title: 'بين المدن',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
