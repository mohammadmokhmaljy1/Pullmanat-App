import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/error_message_translator.dart';

/// طبقة الخدمة — إرسال طلب رحلة مخصصة
class CustomTripService {
  CustomTripService({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// إنشاء طلب رحلة — POST /special_requests/index.php
  Future<String> submitRequest({
    required int userId,
    required String departurePoint,
    required String arrivalPoint,
    required String date,
    required String time,
    required String notes,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.specialRequestsCreate,
        data: {
          'user_id': userId,
          'departure_point': departurePoint,
          'arrival_point': arrivalPoint,
          'date': date,
          'time': time,
          'notes': notes,
        },
      );
      return _parseSuccessMessage(response.data);
    } on DioException catch (error) {
      throw DioClient.instance.handleError(error);
    }
  }

  String _parseSuccessMessage(dynamic data) {
    if (data is Map) {
      final message = data['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return ErrorMessageTranslator.translate(message);
      }
    }
    return 'تم إرسال طلبك بنجاح';
  }
}
