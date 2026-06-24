import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../bookings/models/booking_filter.dart';
import '../../bookings/models/booking_model.dart';
import '../../bookings/services/bookings_service.dart';
import '../../home/models/trip_model.dart';
import '../models/trip_details_args.dart';

/// مزود شاشة تفاصيل الرحلة — حجز أو عرض حجز موجود
class TripDetailsProvider extends ChangeNotifier {
  TripDetailsProvider({BookingsService? bookingsService})
      : _bookingsService = bookingsService ?? BookingsService();

  final BookingsService _bookingsService;

  TripModel? _trip;
  BookingModel? _activeBooking;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  TripModel? get trip => _trip;
  BookingModel? get activeBooking => _activeBooking;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  /// هل المستخدم مسجّل في هذه الرحلة؟
  bool get isRegistered =>
      _activeBooking != null &&
      _activeBooking!.displayStatus != BookingDisplayStatus.cancelled;

  void init(TripDetailsArgs args) {
    _trip = args.trip;
    _activeBooking = args.booking;
    _errorMessage = null;
    notifyListeners();
  }

  /// جلب حجز المستخدم النشط لهذه الرحلة
  Future<void> loadActiveBooking({required int? userId}) async {
    if (_trip == null || userId == null) return;
    if (_activeBooking != null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final bookings =
          await _bookingsService.fetchUserBookings(userId: userId);
      BookingModel? found;
      for (final booking in bookings) {
        if (booking.tripId == _trip!.tripId &&
            booking.displayStatus != BookingDisplayStatus.cancelled) {
          found = booking;
          break;
        }
      }
      _activeBooking = found;
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// حجز الرحلة عبر الـ API
  Future<bool> bookTrip({
    required int userId,
    required int nationalId,
  }) async {
    if (_trip == null) return false;

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final resTime = _formatResTime(_trip!.tripTime);
      await _bookingsService.addReservation(
        userId: userId,
        tripId: _trip!.tripId,
        resTime: resTime,
        seat: 1,
        nationalId: nationalId,
      );

      final bookings =
          await _bookingsService.fetchUserBookings(userId: userId);
      BookingModel? found;
      for (final booking in bookings) {
        if (booking.tripId == _trip!.tripId &&
            booking.displayStatus != BookingDisplayStatus.cancelled) {
          found = booking;
          break;
        }
      }
      _activeBooking = found;
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// إلغاء الحجز الحالي
  Future<bool> cancelBooking() async {
    if (_activeBooking == null) return false;

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _bookingsService.cancelReservation(
        resId: _activeBooking!.resId,
      );
      _activeBooking = null;
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// تعديل بيانات الحجز
  Future<bool> updateBooking({
    required int nationalId,
    String notes = '',
  }) async {
    if (_activeBooking == null || _trip == null) return false;

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    // نُبقي رقم المقعد الحالي في الخادم دون عرضه للمستخدم
    final existingSeat = _activeBooking!.seat ?? 1;

    try {
      await _bookingsService.updateReservation(
        resId: _activeBooking!.resId,
        userId: _activeBooking!.userId,
        tripId: _trip!.tripId,
        resTime: _formatResTime(_trip!.tripTime),
        seat: existingSeat,
        nationalId: nationalId,
        notes: notes,
      );

      _activeBooking = BookingModel(
        resId: _activeBooking!.resId,
        userId: _activeBooking!.userId,
        tripId: _activeBooking!.tripId,
        resStatus: 'active',
        seat: existingSeat,
        nationalId: nationalId,
        notes: notes,
        trip: _trip,
      );
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  String _formatResTime(String tripTime) {
    if (tripTime.length >= 8) return tripTime.substring(0, 8);
    if (tripTime.length >= 5) return '${tripTime.substring(0, 5)}:00';
    return '10:00:00';
  }
}
