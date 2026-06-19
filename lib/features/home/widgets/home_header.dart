import 'package:flutter/material.dart';

/// شعار التطبيق في الشاشة الرئيسية
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: Image.asset(
          'assets/images/logo_light.png',
          height: 48,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
