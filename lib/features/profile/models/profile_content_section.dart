/// قسم واحد داخل صفحات المساعدة والسياسات
class ProfileContentSection {
  const ProfileContentSection({
    required this.title,
    this.paragraphs = const [],
    this.bulletPoints = const [],
  });

  final String title;
  final List<String> paragraphs;
  final List<String> bulletPoints;
}

/// صفحة محتوى كاملة — عنوان رئيسي + أقسام
class ProfileContentPage {
  const ProfileContentPage({
    required this.title,
    required this.sections,
    this.intro,
  });

  final String title;
  final String? intro;
  final List<ProfileContentSection> sections;
}
