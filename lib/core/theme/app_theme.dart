import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// إعدادات الثيم العامة للتطبيق
class AppTheme {
  AppTheme._();

  /// تنسيق شريط الحالة — أيقونات سوداء على جميع الشاشات
  static const SystemUiOverlayStyle statusBarStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

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
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: statusBarStyle,
      ),
    );
  }
}
