import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../models/company_model.dart';

/// طبقة الخدمة — جلب شركات النقل من الـ API
class CompaniesService {
  CompaniesService({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// جلب جميع الشركات — GET /company/index.php
  Future<List<CompanyModel>> fetchCompanies() async {
    try {
      final response = await _dio.get(ApiEndpoints.companiesList);
      return _parseCompaniesList(response.data);
    } on DioException catch (error) {
      throw DioClient.instance.handleError(error);
    }
  }

  /// استخراج قائمة الشركات من استجابة الـ API
  List<CompanyModel> _parseCompaniesList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => CompanyModel.fromJson(Map<String, dynamic>.from(item)))
          .where((company) => company.companyName.isNotEmpty)
          .toList();
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      for (final key in ['data', 'companies', 'results']) {
        if (map[key] is List) {
          return (map[key] as List)
              .whereType<Map>()
              .map((item) =>
                  CompanyModel.fromJson(Map<String, dynamic>.from(item)))
              .where((company) => company.companyName.isNotEmpty)
              .toList();
        }
      }

      if (map.containsKey('company_id')) {
        return [CompanyModel.fromJson(map)];
      }

      throw ApiException(map['message']?.toString() ?? 'فشل جلب الشركات');
    }

    throw ApiException('استجابة غير متوقعة من الخادم');
  }

  /// بيانات احتياطية عند فشل الـ API — للعرض التعليمي
  List<CompanyModel> mockCompanies() {
    return const [
      CompanyModel(
        companyId: 3,
        companyName: 'Pullmanat Transport',
        destinations: 'Damascus, Homs, Aleppo',
        phone: 933445566,
        email: 'info@pullmanat.com',
        registrationNumber: 101010,
        isActive: true,
      ),
      CompanyModel(
        companyId: 2,
        companyName: 'Al Noor Transport',
        destinations: 'Damascus - Aleppo',
        phone: 999999999,
        email: 'info@alnoor.com',
        registrationNumber: 123456,
        isActive: true,
      ),
    ];
  }
}
