import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../home/services/trips_service.dart';
import '../models/booking_model.dart';

/// طبقة الخدمة — جلب حجوزات المستخدم
class BookingsService {
  BookingsService({
    Dio? dio,
    TripsService? tripsService,
  })  : _dio = dio ?? DioClient.instance.dio,
        _tripsService = tripsService ?? TripsService();

  final Dio _dio;
  final TripsService _tripsService;

  /// جلب حجوزات مستخدم — GET /reservations/index.php?user_id=
  Future<List<BookingModel>> fetchUserBookings({required int userId}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.reservationsByUser,
        queryParameters: {'user_id': userId},
      );

      var bookings = _parseBookingsList(response.data);
      bookings = await _mergeTripsData(bookings);
      return bookings;
    } on DioException catch (error) {
      // احتياط: GET مع body عند فشل query params
      if (error.response?.statusCode == 403 ||
          error.response?.statusCode == 405) {
        try {
          final response = await _dio.get(
            ApiEndpoints.reservationsByUser,
            data: {'user_id': userId},
          );
          var bookings = _parseBookingsList(response.data);
          bookings = await _mergeTripsData(bookings);
          return bookings;
        } on DioException catch (fallbackError) {
          throw DioClient.instance.handleError(fallbackError);
        }
      }
      throw DioClient.instance.handleError(error);
    }
  }

  /// ربط كل حجز برحلته من trips/view.php
  Future<List<BookingModel>> _mergeTripsData(
    List<BookingModel> bookings,
  ) async {
    if (bookings.every((b) => b.trip != null)) return bookings;

    final trips = await _tripsService.fetchAllTrips();
    final tripsMap = {for (final t in trips) t.tripId: t};

    return bookings.map((booking) {
      if (booking.trip != null) return booking;
      final trip = tripsMap[booking.tripId];
      return trip != null ? booking.withTrip(trip) : booking;
    }).toList();
  }

  List<BookingModel> _parseBookingsList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => BookingModel.fromJson(Map<String, dynamic>.from(item)))
          .where((b) => b.resId > 0)
          .toList();
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      for (final key in ['data', 'reservations', 'results']) {
        if (map[key] is List) {
          return (map[key] as List)
              .whereType<Map>()
              .map((item) =>
                  BookingModel.fromJson(Map<String, dynamic>.from(item)))
              .where((b) => b.resId > 0)
              .toList();
        }
      }

      if (map.containsKey('res_id')) {
        return [BookingModel.fromJson(map)];
      }

      throw ApiException(map['message']?.toString() ?? 'فشل جلب الحجوزات');
    }

    throw ApiException('استجابة غير متوقعة من الخادم');
  }

  /// إنشاء حجز — POST /reservations/add.php
  Future<void> addReservation({
    required int userId,
    required int tripId,
    required String resTime,
    required int seat,
    required int nationalId,
    String notes = '',
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.reservationsAdd,
        data: {
          'user_id': userId,
          'trip_id': tripId,
          'res_time': resTime,
          'res_status': 'active',
          'seat': seat,
          'national_id': nationalId,
          'nods': notes,
        },
      );
    } on DioException catch (error) {
      throw DioClient.instance.handleError(error);
    }
  }

  /// تحديث حجز — PUT /reservations/update.php
  Future<void> updateReservation({
    required int resId,
    required int userId,
    required int tripId,
    required String resTime,
    required int seat,
    required int nationalId,
    String notes = '',
  }) async {
    final body = {
      'res_id': resId,
      'user_id': userId,
      'trip_id': tripId,
      'res_time': resTime,
      'res_status': 'active',
      'seat': seat,
      'national_id': nationalId,
      'nods': notes,
    };

    try {
      await _dio.put(ApiEndpoints.reservationsUpdate, data: body);
    } on DioException catch (error) {
      if (error.response?.statusCode == 405) {
        await _dio.post(ApiEndpoints.reservationsUpdate, data: body);
        return;
      }
      throw DioClient.instance.handleError(error);
    }
  }

  /// إلغاء حجز — PUT /reservations/status.php
  Future<void> cancelReservation({required int resId}) async {
    try {
      await _dio.put(
        ApiEndpoints.reservationsCancel,
        data: {'res_id': resId},
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 405) {
        await _dio.post(
          ApiEndpoints.reservationsCancel,
          data: {'res_id': resId},
        );
        return;
      }
      throw DioClient.instance.handleError(error);
    }
  }
}
