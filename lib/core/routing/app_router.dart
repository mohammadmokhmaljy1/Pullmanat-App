import 'package:go_router/go_router.dart';

import '../../features/home/screens/home_placeholder_screen.dart';
import '../../features/splash/screens/splash_loading_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import 'app_routes.dart';

/// إعداد التوجيه (Routing) للتطبيق باستخدام go_router
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.splashLoading,
        builder: (context, state) => const SplashLoadingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePlaceholderScreen(),
      ),
    ],
  );
}
