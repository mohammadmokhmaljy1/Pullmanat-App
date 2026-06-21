import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../models/booking_filter.dart';
import '../models/booking_model.dart';
import '../services/bookings_service.dart';

/// مزود شاشة حجوزاتي — جلب الحجوزات وتصفيتها
class BookingsProvider extends ChangeNotifier {
  BookingsProvider({BookingsService? bookingsService})
      : _bookingsService = bookingsService ?? BookingsService();

  final BookingsService _bookingsService;

  List<BookingModel> _bookings = [];
  BookingFilter _selectedFilter = BookingFilter.all;
  bool _isLoading = false;
  String? _errorMessage;

  List<BookingModel> get bookings => _bookings;
  BookingFilter get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// الحجوزات بعد تطبيق الفلتر النشط
  List<BookingModel> get filteredBookings {
    switch (_selectedFilter) {
      case BookingFilter.all:
        return _bookings;
      case BookingFilter.upcoming:
        return _bookings
            .where((b) => b.displayStatus == BookingDisplayStatus.upcoming)
            .toList();
      case BookingFilter.cancelled:
        return _bookings
            .where((b) => b.displayStatus == BookingDisplayStatus.cancelled)
            .toList();
      case BookingFilter.completed:
        return _bookings
            .where((b) => b.displayStatus == BookingDisplayStatus.completed)
            .toList();
    }
  }

  void setFilter(BookingFilter filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
  }

  /// تحميل حجوزات المستخدم من الـ API
  Future<void> loadBookings({required int? userId}) async {
    if (userId == null || userId <= 0) {
      _bookings = [];
      _errorMessage = 'يجب تسجيل الدخول لعرض الحجوزات';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await _bookingsService.fetchUserBookings(userId: userId);
      _bookings.sort((a, b) => b.resId.compareTo(a.resId));
    } on ApiException catch (error) {
      _errorMessage = error.message;
      _bookings = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
