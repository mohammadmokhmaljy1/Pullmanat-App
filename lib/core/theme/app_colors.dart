import 'package:flutter/material.dart';

/// ألوان التطبيق الأساسية المستخرجة من تصاميم Figma
class AppColors {
  AppColors._();

  /// لون خلفية شاشة البداية (Splash) — أزرق داكن
  static const Color splashBackground = Color(0xFF243E4E);

  /// لون خلفية شاشات التعريف (Getting Started)
  static const Color onboardingBackground = Color(0xFF1E3A4C);

  /// اللون الأزرق الفاتح المستخدم في الشعار ومؤشر التحميل
  static const Color brandLightBlue = Color(0xFF4AB3E2);

  /// اللون الأبيض للنصوص والعناصر الفاتحة
  static const Color white = Color(0xFFFFFFFF);

  /// لون زر التالي الدائري في شاشات التعريف
  static const Color onboardingNextButton = Color(0xFFE8E8E3);

  /// لون النقاط غير النشطة في مؤشر الصفحات
  static const Color onboardingDotInactive = Color(0xFF6B8A9A);

  /// لون زر "هيا نبدأ" في الصفحة الأخيرة
  static const Color onboardingStartButton = Color(0xFF1A2F3D);

  /// لون خلفية شاشات المصادقة (Sign in / Sign up)
  static const Color authBackground = Color(0xFF1B3A4B);

  /// لون خلفية حقول الإدخال
  static const Color authInputBackground = Color(0xFFE0E0DA);

  /// لون النص داخل حقول الإدخال
  static const Color authInputText = Color(0xFF5A7A8A);

  /// لون زر تسجيل الدخول / إنشاء حساب
  static const Color authPrimaryButton = Color(0xFF2A5068);

  /// لون الزر المعطّل
  static const Color authDisabledButton = Color(0xFF4A5E6A);

  /// لون رسائل الخطأ
  static const Color authError = Color(0xFFE53935);

  /// لون الرابط التفاعلي
  static const Color authLink = Color(0xFF8AB4C7);
}
