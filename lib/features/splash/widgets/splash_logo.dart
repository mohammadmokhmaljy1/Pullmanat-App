import 'package:flutter/material.dart';

/// ويدجت الشعار المعروض في منتصف شاشات البداية
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_dark.png',
      width: 220,
      fit: BoxFit.contain,
    );
  }
}
