import '../../../core/utils/syrian_cities.dart';
import '../../home/models/trip_model.dart';
import 'booking_filter.dart';

/// نموذج الحجز — يدمج بيانات reservations مع trips
class BookingModel {
  const BookingModel({
    required this.resId,
    required this.userId,
    required this.tripId,
    required this.resStatus,
    this.seat,
    this.resTime,
    this.notes,
    this.trip,
  });

  final int resId;
  final int userId;
  final int tripId;
  final String resStatus;
  final int? seat;
  final String? resTime;
  final String? notes;
  final TripModel? trip;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    TripModel? trip;
    if (json['trip'] is Map) {
      trip = TripModel.fromJson(Map<String, dynamic>.from(json['trip']));
    } else if (json.containsKey('departure_city')) {
      trip = TripModel.fromJson(json);
    }

    return BookingModel(
      resId: _parseInt(json['res_id']),
      userId: _parseInt(json['user_id']),
      tripId: _parseInt(json['trip_id']),
      resStatus: json['res_status']?.toString() ?? '',
      seat: _parseOptionalInt(json['seat']),
      resTime: json['res_time']?.toString(),
      notes: json['nods']?.toString(),
      trip: trip,
    );
  }

  /// دمج بيانات الرحلة من قائمة trips/view.php
  BookingModel withTrip(TripModel tripData) {
    return BookingModel(
      resId: resId,
      userId: userId,
      tripId: tripId,
      resStatus: resStatus,
      seat: seat,
      resTime: resTime,
      notes: notes,
      trip: tripData,
    );
  }

  /// حساب حالة العرض للفلاتر والشارة
  BookingDisplayStatus get displayStatus {
    final normalized = resStatus.trim().toLowerCase();

    if (normalized.contains('cancel')) {
      return BookingDisplayStatus.cancelled;
    }
    if (normalized.contains('complete') || normalized.contains('done')) {
      return BookingDisplayStatus.completed;
    }

    final tripDate = _parseTripDate();
    if (tripDate != null) {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      if (tripDate.isBefore(todayDate)) {
        return BookingDisplayStatus.completed;
      }
      if (normalized == 'active' || normalized.isEmpty) {
        return BookingDisplayStatus.upcoming;
      }
    }

    if (normalized == 'active') return BookingDisplayStatus.upcoming;
    return BookingDisplayStatus.unknown;
  }

  String get fromCity =>
      SyrianCities.toDisplayName(trip?.departureCity ?? '—');

  String get toCity =>
      SyrianCities.toDisplayName(trip?.destinationCity ?? '—');

  String get formattedTime {
    final time = trip?.formattedTime ?? resTime ?? '';
    if (time.length >= 5) return _formatTime12h(time.substring(0, 5));
    return time;
  }

  String get formattedPrice {
    if (trip == null) return 'السعر: —';
    return 'السعر: ${trip!.tripPrice.toStringAsFixed(0)} ل.س';
  }

  String get seatLabel {
    if (seat == null || seat! <= 0) return 'المقعد: —';
    return 'المقعد: $seat';
  }

  DateTime? _parseTripDate() {
    final raw = trip?.tripDate;
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  static String _formatTime12h(String time24) {
    final parts = time24.split(':');
    if (parts.length < 2) return time24;
    var hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return '$hour:$minute$period';
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int? _parseOptionalInt(dynamic value) {
    if (value == null) return null;
    return _parseInt(value);
  }
}
