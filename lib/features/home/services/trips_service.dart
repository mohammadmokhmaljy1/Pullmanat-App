import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../models/trip_model.dart';

/// طبقة الخدمة — جلب الرحلات من الـ API
class TripsService {
  TripsService({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// جلب جميع الرحلات — GET /trips/view.php
  Future<List<TripModel>> fetchAllTrips() async {
    try {
      final response = await _dio.get(ApiEndpoints.tripsView);
      return _parseTripsList(response.data);
    } on DioException catch (error) {
      throw DioClient.instance.handleError(error);
    }
  }

  /// البحث عن رحلات — GET /trips/index.php
  Future<List<TripModel>> searchTrips({
    String? departureCity,
    String? destinationCity,
    String? tripDate,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.tripsSearch,
        data: {
          if (departureCity != null && departureCity.isNotEmpty)
            'departure_city': departureCity,
          if (destinationCity != null && destinationCity.isNotEmpty)
            'destination_city': destinationCity,
          if (tripDate != null && tripDate.isNotEmpty) 'trip_date': tripDate,
        },
      );
      return _parseTripsList(response.data);
    } on DioException catch (error) {
      throw DioClient.instance.handleError(error);
    }
  }

  /// استخراج قائمة الرحلات من استجابة الـ API بمرونة
  List<TripModel> _parseTripsList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => TripModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      for (final key in ['data', 'trips', 'results']) {
        if (map[key] is List) {
          return (map[key] as List)
              .whereType<Map>()
              .map((item) => TripModel.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
      }

      if (map.containsKey('trip_id')) {
        return [TripModel.fromJson(map)];
      }

      throw ApiException(map['message']?.toString() ?? 'فشل جلب الرحلات');
    }

    throw ApiException('استجابة غير متوقعة من الخادم');
  }
}
