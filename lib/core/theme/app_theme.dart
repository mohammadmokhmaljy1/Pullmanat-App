import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// إعدادات الثيم العامة للتطبيق
class AppTheme {
  AppTheme._();

  /// أيقونات شريط الحالة بيضاء — للخلفيات الداكنة (SystemUiOverlayStyle.light)
  static final SystemUiOverlayStyle overlayLightIcons =
      SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  );

  /// أيقونات شريط الحالة سوداء — للخلفيات الفاتحة (SystemUiOverlayStyle.dark)
  static final SystemUiOverlayStyle overlayDarkIcons =
      SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
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
      appBarTheme: AppBarTheme(
        systemOverlayStyle: overlayLightIcons,
      ),
    );
  }
}
