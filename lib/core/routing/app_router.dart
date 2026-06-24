import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/sign_in_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/bookings/screens/my_bookings_screen.dart';
import '../../features/companies/screens/companies_screen.dart';
import '../../features/custom_trip/screens/custom_trip_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/getting_started_screen.dart';
import '../../features/profile/screens/profile_content_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/data/profile_legal_content.dart';
import '../../features/trip_details/models/trip_details_args.dart';
import '../../features/trip_details/screens/trip_details_screen.dart';
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
      GoRoute(
        path: AppRoutes.companies,
        builder: (context, state) => const CompaniesScreen(),
      ),
      GoRoute(
        path: AppRoutes.customTrip,
        builder: (context, state) => const CustomTripScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookings,
        builder: (context, state) => const MyBookingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.tripDetails,
        builder: (context, state) {
          final args = state.extra as TripDetailsArgs?;
          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('بيانات الرحلة غير متوفرة')),
            );
          }
          return TripDetailsScreen(args: args);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileHelp,
        builder: (context, state) => const ProfileContentScreen(
          page: ProfileLegalContent.help,
        ),
      ),
      GoRoute(
        path: AppRoutes.profilePrivacy,
        builder: (context, state) => const ProfileContentScreen(
          page: ProfileLegalContent.privacy,
        ),
      ),
      GoRoute(
        path: AppRoutes.profileTerms,
        builder: (context, state) => const ProfileContentScreen(
          page: ProfileLegalContent.terms,
        ),
      ),
    ],
  );
}
