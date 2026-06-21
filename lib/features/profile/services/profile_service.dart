import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/error_message_translator.dart';
import '../../auth/models/user_model.dart';

/// طبقة الخدمة — جلب وتحديث بيانات الملف الشخصي
class ProfileService {
  ProfileService({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// جلب بيانات المستخدم — GET /users/index.php?user_id=
  Future<UserModel> fetchProfile({required int userId}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.userProfile,
        queryParameters: {'user_id': userId},
      );
      return _parseUserResponse(response.data);
    } on DioException catch (error) {
      throw DioClient.instance.handleError(error);
    }
  }

  /// تحديث الملف الشخصي — PUT /users/update.php
  Future<UserModel> updateProfile({
    required int userId,
    required String name,
    required int phone,
    String? image,
  }) async {
    final body = {
      'user_id': userId,
      'name': name.trim(),
      'phone': phone,
      'image': image ?? 'profile.png',
    };

    try {
      final response = await _dio.put(ApiEndpoints.userUpdate, data: body);
      return _parseUserResponse(response.data);
    } on DioException catch (error) {
      // بعض خوادم PHP لا تدعم PUT — نجرب POST كاحتياط
      if (error.response?.statusCode == 405 ||
          error.response?.statusCode == 404) {
        try {
          final response =
              await _dio.post(ApiEndpoints.userUpdate, data: body);
          return _parseUserResponse(response.data);
        } on DioException catch (fallbackError) {
          throw DioClient.instance.handleError(fallbackError);
        }
      }
      throw DioClient.instance.handleError(error);
    }
  }

  UserModel _parseUserResponse(dynamic data) {
    final user = UserModel.tryParseFromResponse(data);
    if (user != null) return user;

    if (data is Map) {
      throw ApiException(
        ErrorMessageTranslator.translate(
          data['message']?.toString() ?? 'فشلت العملية',
        ),
      );
    }

    throw ApiException('استجابة غير متوقعة من الخادم');
  }

  /// تحويل رقم الهاتف لصيغة رقمية كما يتوقعها الـ API
  int parsePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final normalized = digits.startsWith('963') ? digits.substring(3) : digits;
    final trimmed =
        normalized.startsWith('0') ? normalized.substring(1) : normalized;
    return int.parse(trimmed);
  }
}
