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

  /// لون خلفية الشاشة الرئيسية
  static const Color homeBackground = Color(0xFFF4F4F0);

  /// لون خلفية شريط البحث وبطاقات الفئات
  static const Color homeSurface = Color(0xFFE6EBEF);

  /// لون النص الثانوي في الشاشة الرئيسية
  static const Color homeTextSecondary = Color(0xFF5A6B75);

  /// لون زر التفاصيل البرتقالي
  static const Color homeDetailsButton = Color(0xFFF5A623);

  /// لون شريط التنقل السفلي
  static const Color homeNavBar = Color(0xFF1E3A4C);

  /// لون زر الحفظ في نافذة تعديل الملف الشخصي
  static const Color profileSaveButton = Color(0xFF2E8B57);

  /// لون شارة التحقق على صورة الملف الشخصي
  static const Color profileVerifiedBadge = Color(0xFF43A047);
}
