import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../models/trip_model.dart';
import '../services/trips_service.dart';

/// مزود الشاشة الرئيسية — يدير جلب الرحلات والبحث
class HomeProvider extends ChangeNotifier {
  HomeProvider({TripsService? tripsService})
      : _tripsService = tripsService ?? TripsService();

  final TripsService _tripsService;

  List<TripModel> _allTrips = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<TripModel> get allTrips => _allTrips;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// الرحلات المعروضة بعد تطبيق البحث المحلي
  List<TripModel> get filteredTrips {
    if (_searchQuery.trim().isEmpty) return _allTrips;

    final query = _searchQuery.trim().toLowerCase();
    return _allTrips.where((trip) {
      return trip.departureCity.toLowerCase().contains(query) ||
          trip.destinationCity.toLowerCase().contains(query) ||
          trip.routeDescription.toLowerCase().contains(query);
    }).toList();
  }

  /// تحميل الرحلات المقترحة من الـ API
  Future<void> loadSuggestedTrips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allTrips = await _tripsService.fetchAllTrips();
    } on ApiException catch (error) {
      _errorMessage = error.message;
      _allTrips = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// تحديث نص البحث وتصفية القائمة محلياً
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// البحث عبر الـ API عند الحاجة (مدن محددة)
  Future<void> searchFromApi({
    String? departureCity,
    String? destinationCity,
    String? tripDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allTrips = await _tripsService.searchTrips(
        departureCity: departureCity,
        destinationCity: destinationCity,
        tripDate: tripDate,
      );
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
