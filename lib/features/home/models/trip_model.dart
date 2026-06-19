import '../../../core/utils/syrian_cities.dart';

/// نموذج بيانات الرحلة — مطابق لجدول trips في قاعدة البيانات
class TripModel {
  const TripModel({
    required this.tripId,
    required this.departureCity,
    required this.destinationCity,
    required this.tripDate,
    required this.tripTime,
    required this.tripPrice,
    this.busNumber,
    this.pointId,
    this.companyId,
  });

  final int tripId;
  final String departureCity;
  final String destinationCity;
  final String tripDate;
  final String tripTime;
  final double tripPrice;
  final int? busNumber;
  final int? pointId;
  final int? companyId;

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      tripId: _parseInt(json['trip_id']),
      departureCity: json['departure_city']?.toString() ?? '',
      destinationCity: json['destination_city']?.toString() ?? '',
      tripDate: json['trip_date']?.toString() ?? '',
      tripTime: json['trip_time']?.toString() ?? '',
      tripPrice: _parseDouble(json['trip_price']),
      busNumber: _parseOptionalInt(json['bus_namber']),
      pointId: _parseOptionalInt(json['point_id']),
      companyId: _parseOptionalInt(json['company_id']),
    );
  }

  /// نص المسار كما في تصميم Figma
  String get routeDescription {
    final from = SyrianCities.toDisplayName(departureCity);
    final to = SyrianCities.toDisplayName(destinationCity);
    return 'من $from الى $to الانطلاق الساعة $formattedTime';
  }

  /// عرض السعر بصيغة عربية
  String get formattedPrice => 'السعر: ${tripPrice.toStringAsFixed(0)} ل.س';

  /// تحويل الوقت من 14:30:00 إلى 14:30
  String get formattedTime {
    if (tripTime.length >= 5) return tripTime.substring(0, 5);
    return tripTime;
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static int? _parseOptionalInt(dynamic value) {
    if (value == null) return null;
    return _parseInt(value);
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
