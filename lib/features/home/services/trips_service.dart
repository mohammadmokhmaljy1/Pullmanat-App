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

  /// البحث عن رحلات — POST /trips/index.php مع user_id في body
  Future<List<TripModel>> searchTrips({
    required int userId,
    required String departureCity,
    required String destinationCity,
    required String tripDate,
  }) async {
    final body = {
      'user_id': userId,
      'departure_city': departureCity,
      'destination_city': destinationCity,
      'trip_date': tripDate,
    };

    try {
      // POST — متوافق مع PHP API ولا يُحجب من CDN
      final response = await _dio.post(ApiEndpoints.tripsSearch, data: body);
      return _parseTripsList(response.data);
    } on DioException catch (error) {
      // احتياط: GET مع query parameters
      if (error.response?.statusCode == 403 ||
          error.response?.statusCode == 405) {
        try {
          final response = await _dio.get(
            ApiEndpoints.tripsSearch,
            queryParameters: body,
          );
          return _parseTripsList(response.data);
        } on DioException catch (fallbackError) {
          throw DioClient.instance.handleError(fallbackError);
        }
      }
      throw DioClient.instance.handleError(error);
    }
  }

  /// تصفية الرحلات محلياً — احتياط عند فشل API البحث
  List<TripModel> filterTripsLocally({
    required List<TripModel> trips,
    required String departureCity,
    required String destinationCity,
    required String tripDate,
  }) {
    return trips.where((trip) {
      final matchesDeparture =
          trip.departureCity.toLowerCase() == departureCity.toLowerCase();
      final matchesDestination =
          trip.destinationCity.toLowerCase() == destinationCity.toLowerCase();
      final matchesDate = trip.tripDate.startsWith(tripDate);
      return matchesDeparture && matchesDestination && matchesDate;
    }).toList();
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
