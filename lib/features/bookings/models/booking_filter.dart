/// فلاتر عرض قائمة الحجوزات — مطابقة لتصميم Figma
enum BookingFilter {
  all('الكل'),
  upcoming('القادمة'),
  cancelled('الملغاة'),
  completed('المكتملة');

  const BookingFilter(this.label);
  final String label;
}

/// حالة العرض المحسوبة لكل حجز
enum BookingDisplayStatus {
  upcoming('قادمة'),
  completed('المكتملة'),
  cancelled('ملغاة'),
  unknown('غير محددة');

  const BookingDisplayStatus(this.label);
  final String label;
}
