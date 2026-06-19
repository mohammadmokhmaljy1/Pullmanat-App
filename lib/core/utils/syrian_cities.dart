/// قائمة المدن السورية المتاحة في البحث
class SyrianCities {
  SyrianCities._();

  static const List<String> all = [
    'حلب',
    'دمشق',
    'حمص',
    'الرقة',
    'حماة',
    'القامشلي',
    'الحسكة',
    'منبج',
    'النيرب',
    'عفرين',
    'دير الزور',
    'درعا',
    'ريف دمشق',
    'طرطوس',
    'اللاذقية',
    'سهل الغاب',
    'تدمر',
    'السويداء',
    'القنيطرة',
    'الجولان',
    'عين العرب',
    'الطبقة',
    'البوكمال',
    'القدموس',
    'بانياس',
    'جبلة',
    'سلمية',
    'معرة النعمان',
    'إدلب',
    'اعزاز',
    'جرابلس',
    'تل أبيض',
    'الباب',
    'الرستن',
  ];

  /// تحويل اسم المدينة العربي لما يتوقعه الـ API (إن وُجد)
  static String toApiName(String arabicCity) {
    return _apiNames[arabicCity] ?? arabicCity;
  }

  /// تحويل اسم المدينة من الـ API للعرض بالعربية
  static String toDisplayName(String apiCity) {
    for (final entry in _apiNames.entries) {
      if (entry.value.toLowerCase() == apiCity.toLowerCase()) {
        return entry.key;
      }
    }
    return apiCity;
  }

  static const Map<String, String> _apiNames = {
    'حلب': 'Aleppo',
    'دمشق': 'Damascus',
    'حمص': 'Homs',
    'اللاذقية': 'Latakia',
    'طرطوس': 'Tartus',
    'درعا': 'Daraa',
    'دير الزور': 'Deir ez-Zor',
    'الرقة': 'Raqqa',
    'حماة': 'Hama',
    'إدلب': 'Idlib',
    'السويداء': 'As-Suwayda',
    'القنيطرة': 'Quneitra',
    'ريف دمشق': 'Damascus Countryside',
  };
}
