import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../models/user_model.dart';

/// طبقة الخدمة — كل طلبات المصادقة عبر Dio
class AuthService {
  AuthService({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// تسجيل الدخول — POST /users/login.php
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    try {
      // إذا كان المدخل بريداً نرسله في email، وإلا نرسل الهاتف في phone
      final Map<String, dynamic> body;
      if (identifier.contains('@')) {
        body = {'email': identifier.trim(), 'password': password};
      } else {
        body = {
          'phone': _parsePhone(identifier),
          'password': password,
        };
      }

      final response = await _dio.post(ApiEndpoints.userLogin, data: body);
      return _parseUserResponse(response.data);
    } on DioException catch (error) {
      throw DioClient.instance.handleError(error);
    }
  }

  /// إنشاء حساب — POST /users/create.php
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.userCreate,
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'phone': _parsePhone(phone),
          'password': password,
          'image': 'profile.png',
        },
      );
      return _parseUserResponse(response.data);
    } on DioException catch (error) {
      throw DioClient.instance.handleError(error);
    }
  }

  /// استخراج بيانات المستخدم من استجابة الـ API بمرونة
  UserModel _parseUserResponse(dynamic data) {
    if (data is! Map) {
      throw ApiException('استجابة غير متوقعة من الخادم');
    }

    final map = Map<String, dynamic>.from(data);

    if (map.containsKey('user') && map['user'] is Map) {
      return UserModel.fromJson(Map<String, dynamic>.from(map['user']));
    }
    if (map.containsKey('data') && map['data'] is Map) {
      return UserModel.fromJson(Map<String, dynamic>.from(map['data']));
    }
    if (map.containsKey('user_id')) {
      return UserModel.fromJson(map);
    }

    throw ApiException(map['message']?.toString() ?? 'فشلت العملية');
  }

  /// تحويل رقم الهاتف لصيغة رقمية كما يتوقعها الـ API
  int _parsePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final normalized = digits.startsWith('963') ? digits.substring(3) : digits;
    return int.parse(normalized.startsWith('0') ? normalized.substring(1) : normalized);
  }
}
