/// نموذج نقطة الانطلاق — مطابق لجدول departure_points
class DeparturePointModel {
  const DeparturePointModel({
    required this.stationId,
    required this.cityName,
    required this.stationName,
    this.stationLocation,
  });

  final int stationId;
  final String cityName;
  final String stationName;
  final String? stationLocation;

  factory DeparturePointModel.fromJson(Map<String, dynamic> json) {
    return DeparturePointModel(
      stationId: int.tryParse(json['station_id']?.toString() ?? '') ?? 0,
      cityName: json['city_name']?.toString() ?? '',
      stationName: json['station_name']?.toString() ?? '',
      stationLocation: json['station_location']?.toString(),
    );
  }
}
