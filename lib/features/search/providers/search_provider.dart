import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/syrian_cities.dart';
import '../../home/models/trip_model.dart';
import '../../home/services/trips_service.dart';
import '../models/departure_point_model.dart';
import '../services/departure_points_service.dart';

/// مزود شاشة البحث — يدير النموذج وطلبات الـ API
class SearchProvider extends ChangeNotifier {
  SearchProvider({
    TripsService? tripsService,
    DeparturePointsService? departurePointsService,
  })  : _tripsService = tripsService ?? TripsService(),
        _departurePointsService =
            departurePointsService ?? DeparturePointsService();

  final TripsService _tripsService;
  final DeparturePointsService _departurePointsService;

  String? _fromCity;
  String? _toCity;
  DeparturePointModel? _departurePoint;
  DateTime? _tripDate;

  List<DeparturePointModel> _departurePoints = [];
  List<TripModel> _searchResults = [];

  bool _isSearching = false;
  bool _isLoadingPoints = false;
  String? _errorMessage;

  String? get fromCity => _fromCity;
  String? get toCity => _toCity;
  DeparturePointModel? get departurePoint => _departurePoint;
  DateTime? get tripDate => _tripDate;
  List<DeparturePointModel> get departurePoints => _departurePoints;
  List<TripModel> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  bool get isLoadingPoints => _isLoadingPoints;
  String? get errorMessage => _errorMessage;

  bool get canSearch =>
      _fromCity != null &&
      _toCity != null &&
      _departurePoint != null &&
      _tripDate != null &&
      !_isSearching;

  Future<void> setFromCity(String city) async {
    _fromCity = city;
    _departurePoint = null;
    _departurePoints = [];
    notifyListeners();

    _isLoadingPoints = true;
    notifyListeners();

    _departurePoints = await _departurePointsService.fetchByCity(city);

    _isLoadingPoints = false;
    notifyListeners();
  }

  void setToCity(String city) {
    _toCity = city;
    notifyListeners();
  }

  void setDeparturePoint(DeparturePointModel point) {
    _departurePoint = point;
    notifyListeners();
  }

  void setTripDate(DateTime date) {
    _tripDate = date;
    notifyListeners();
  }

  /// تنفيذ البحث — يتطلب user_id من الجلسة المحلية
  Future<bool> searchTrips({required int? userId}) async {
    if (!canSearch) return false;

    if (userId == null || userId <= 0) {
      _errorMessage = 'يجب تسجيل الدخول للبحث عن رحلات';
      notifyListeners();
      return false;
    }

    _isSearching = true;
    _errorMessage = null;
    notifyListeners();

    final apiDeparture = SyrianCities.toApiName(_fromCity!);
    final apiDestination = SyrianCities.toApiName(_toCity!);
    final apiDate = _formatDateForApi(_tripDate!);

    try {
      final results = await _tripsService.searchTrips(
        userId: userId,
        departureCity: apiDeparture,
        destinationCity: apiDestination,
        tripDate: apiDate,
      );

      _searchResults = _filterByDeparturePoint(results);
      return true;
    } on ApiException {
      // احتياط: تصفية محلية من trips/view.php
      try {
        final allTrips = await _tripsService.fetchAllTrips();
        _searchResults = _filterByDeparturePoint(
          _tripsService.filterTripsLocally(
            trips: allTrips,
            departureCity: apiDeparture,
            destinationCity: apiDestination,
            tripDate: apiDate,
          ),
        );
        return true;
      } on ApiException catch (fallbackError) {
        _errorMessage = fallbackError.message;
        _searchResults = [];
        return false;
      }
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  List<TripModel> _filterByDeparturePoint(List<TripModel> results) {
    return results.where((trip) {
      if (_departurePoint == null || _departurePoint!.stationId == 0) {
        return true;
      }
      if (trip.pointId == null) return true;
      return trip.pointId == _departurePoint!.stationId;
    }).toList();
  }

  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String formatDateForDisplay(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
