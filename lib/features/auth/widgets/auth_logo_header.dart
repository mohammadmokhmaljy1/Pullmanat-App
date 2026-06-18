import 'package:flutter/material.dart';

/// شعار التطبيق في شاشات المصادقة
class AuthLogoHeader extends StatelessWidget {
  const AuthLogoHeader({
    super.key,
    this.alignment = Alignment.center,
    this.height = 80,
  });

  final Alignment alignment;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Image.asset(
        'assets/images/logo_dark.png',
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
