import 'package:go_router/go_router.dart';

import '../../features/auth/screens/sign_in_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/getting_started_screen.dart';
import '../../features/search/screens/flight_list_screen.dart';
import '../../features/search/screens/search_screen.dart';
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
        path: AppRoutes.gettingStarted,
        builder: (context, state) => const GettingStartedScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.flightList,
        builder: (context, state) => const FlightListScreen(),
      ),
    ],
  );
}
