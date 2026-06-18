/// نموذج بيانات صفحة واحدة في شاشات التعريف (Getting Started)
class OnboardingPageModel {
  const OnboardingPageModel({
    required this.imagePath,
    required this.title,
  });

  /// مسار صورة التوضيح
  final String imagePath;

  /// العنوان العربي أسفل الصورة
  final String title;
}
