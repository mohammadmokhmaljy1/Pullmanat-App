import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/syrian_cities.dart';
import '../models/departure_point_model.dart';

/// خدمة نقاط الانطلاق — مع بيانات احتياطية عند غياب endpoint القائمة
class DeparturePointsService {
  DeparturePointsService({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// بيانات احتياطية لنقاط الانطلاق حسب المدينة
  static const Map<String, List<String>> _mockStations = {
    'حلب': ['كراج حلب', 'محطة حلب المركزية'],
    'دمشق': ['كراج الراموسة', 'محطة دمشق'],
    'حمص': ['كراج حمص', 'محطة حمص'],
    'اللاذقية': ['كراج اللاذقية'],
    'حماة': ['كراج حماة'],
  };

  /// جلب نقاط الانطلاق لمدينة محددة
  Future<List<DeparturePointModel>> fetchByCity(String city) async {
    try {
      final response = await _dio.get(ApiEndpoints.departurePoints);
      final all = _parseList(response.data);
      final apiCity = SyrianCities.toApiName(city);
      return all
          .where(
            (point) =>
                point.cityName.toLowerCase() == apiCity.toLowerCase() ||
                point.cityName == city,
          )
          .toList();
    } on DioException {
      return _mockPoints(city);
    }
  }

  List<DeparturePointModel> _mockPoints(String city) {
    final stations = _mockStations[city] ?? ['محطة $city'];
    return List.generate(
      stations.length,
      (index) => DeparturePointModel(
        stationId: index + 1,
        cityName: city,
        stationName: stations[index],
      ),
    );
  }

  List<DeparturePointModel> _parseList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => DeparturePointModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (data is Map) {
      for (final key in ['data', 'points', 'departure_points']) {
        if (data[key] is List) {
          return (data[key] as List)
              .whereType<Map>()
              .map((e) => DeparturePointModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }
    }
    return [];
  }
}
