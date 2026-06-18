import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// إعدادات الثيم العامة للتطبيق
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.splashBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandLightBlue,
        brightness: Brightness.dark,
        surface: AppColors.splashBackground,
      ),
      textTheme: GoogleFonts.cairoTextTheme(
        ThemeData.dark().textTheme,
      ),
    );
  }

  /// تنسيق شريط الحالة ليتناسب مع الخلفية الداكنة في شاشة البداية
  static SystemUiOverlayStyle get splashOverlayStyle {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.splashBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    );
  }
}
