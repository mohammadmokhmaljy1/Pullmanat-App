import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../models/company_model.dart';
import '../services/companies_service.dart';

/// مزود شاشة الشركات — يدير جلب وعرض بيانات الشركات
class CompaniesProvider extends ChangeNotifier {
  CompaniesProvider({CompaniesService? companiesService})
      : _companiesService = companiesService ?? CompaniesService();

  final CompaniesService _companiesService;

  List<CompanyModel> _companies = [];
  bool _isLoading = false;
  bool _usedMockData = false;
  String? _errorMessage;

  List<CompanyModel> get companies => _companies;
  bool get isLoading => _isLoading;
  bool get usedMockData => _usedMockData;
  String? get errorMessage => _errorMessage;

  /// الشركات النشطة أولاً ثم غير النشطة
  List<CompanyModel> get sortedCompanies {
    final active = _companies.where((c) => c.isActive).toList();
    final inactive = _companies.where((c) => !c.isActive).toList();
    return [...active, ...inactive];
  }

  /// تحميل الشركات من الـ API مع بيانات احتياطية
  Future<void> loadCompanies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _companiesService.fetchCompanies();
      _companies = _deduplicateById(results);
      _usedMockData = false;
    } on ApiException {
      _companies = _deduplicateById(_companiesService.mockCompanies());
      _usedMockData = true;
      _errorMessage = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// إزالة التكرار حسب معرف الشركة
  List<CompanyModel> _deduplicateById(List<CompanyModel> items) {
    final seen = <int>{};
    return items.where((company) => seen.add(company.companyId)).toList();
  }
}
