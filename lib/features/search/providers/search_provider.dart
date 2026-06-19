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

  /// هل النموذج جاهز للبحث؟
  bool get canSearch =>
      _fromCity != null &&
      _toCity != null &&
      _departurePoint != null &&
      _tripDate != null &&
      !_isSearching;

  /// تحديد مدينة الانطلاق وتحميل نقاط الانطلاق
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

  /// تنفيذ البحث عبر الـ API
  Future<bool> searchTrips() async {
    if (!canSearch) return false;

    _isSearching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _tripsService.searchTrips(
        departureCity: SyrianCities.toApiName(_fromCity!),
        destinationCity: SyrianCities.toApiName(_toCity!),
        tripDate: _formatDateForApi(_tripDate!),
      );

      // تصفية حسب نقطة الانطلاق إذا توفر point_id
      _searchResults = results.where((trip) {
        if (_departurePoint == null || _departurePoint!.stationId == 0) {
          return true;
        }
        if (trip.pointId == null) return true;
        return trip.pointId == _departurePoint!.stationId;
      }).toList();

      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      _searchResults = [];
      return false;
    } finally {
      _isSearching = false;
      notifyListeners();
    }
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
