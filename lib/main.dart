import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/bookings/providers/bookings_provider.dart';
import 'features/companies/providers/companies_provider.dart';
import 'features/custom_trip/providers/custom_trip_provider.dart';
import 'features/home/providers/home_provider.dart';
import 'features/onboarding/providers/onboarding_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/search/providers/search_provider.dart';
import 'features/splash/providers/splash_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.initializeSession();

  runApp(PullmanatApp(authProvider: authProvider));
}

/// نقطة الدخول الرئيسية للتطبيق
class PullmanatApp extends StatelessWidget {
  const PullmanatApp({super.key, required this.authProvider});

  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CompaniesProvider()),
        ChangeNotifierProvider(create: (_) => CustomTripProvider()),
        ChangeNotifierProvider(create: (_) => BookingsProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
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
