import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'api_exception.dart';

/// عميل Dio Singleton — نقطة الدخول الوحيدة لطلبات الشبكة
class DioClient {
  DioClient._();

  static final DioClient instance = DioClient._();

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

  Dio get dio => _dio;

  /// تحويل أخطاء Dio لرسائل مفهومة للمستخدم
  ApiException handleError(DioException error) {
    final response = error.response;

    if (response != null && response.data is Map) {
      final data = response.data as Map;
      final message = data['message'] ?? data['error'] ?? data['msg'];
      if (message != null) {
        return ApiException(message.toString(), statusCode: response.statusCode);
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('انتهت مهلة الاتصال، حاول مجدداً');
      case DioExceptionType.connectionError:
        return ApiException('تعذر الاتصال بالخادم، تحقق من الإنترنت');
      default:
        return ApiException(
          'حدث خطأ غير متوقع',
          statusCode: response?.statusCode,
        );
    }
  }
}
