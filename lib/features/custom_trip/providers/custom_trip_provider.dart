import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/syrian_cities.dart';
import '../services/custom_trip_service.dart';

/// مزود شاشة طلب رحلة مخصصة — يدير النموذج وإرسال الطلب
class CustomTripProvider extends ChangeNotifier {
  CustomTripProvider({CustomTripService? customTripService})
      : _customTripService = customTripService ?? CustomTripService();

  final CustomTripService _customTripService;

  String? _fromCity;
  String? _toCity;
  DateTime? _preferredDate;
  String _preferredTime = '';
  String _notes = '';
  bool _isSubmitting = false;
  String? _errorMessage;

  String? get fromCity => _fromCity;
  String? get toCity => _toCity;
  DateTime? get preferredDate => _preferredDate;
  String get preferredTime => _preferredTime;
  String get notes => _notes;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  /// التحقق من صحة الوقت بصيغة HH:MM
  bool get isPreferredTimeValid {
    final match = _timeRegex.firstMatch(_preferredTime.trim());
    if (match == null) return false;
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    return hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59;
  }

  bool get canSubmit =>
      _fromCity != null &&
      _toCity != null &&
      _preferredDate != null &&
      isPreferredTimeValid &&
      !_isSubmitting;

  static final RegExp _timeRegex = RegExp(r'^(\d{1,2}):(\d{2})$');

  void setFromCity(String city) {
    _fromCity = city;
    notifyListeners();
  }

  void setToCity(String city) {
    _toCity = city;
    notifyListeners();
  }

  void setPreferredDate(DateTime date) {
    _preferredDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  void setPreferredTime(String value) {
    _preferredTime = value;
    notifyListeners();
  }

  void setNotes(String value) {
    _notes = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// إعادة تعيين النموذج بعد الإرسال الناجح
  void resetForm() {
    _fromCity = null;
    _toCity = null;
    _preferredDate = null;
    _preferredTime = '';
    _notes = '';
    _errorMessage = null;
    notifyListeners();
  }

  String formatDateForDisplay(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// إرسال الطلب للـ API مع user_id من الجلسة المحلية
  Future<bool> submitRequest({required int? userId}) async {
    if (!canSubmit) return false;

    if (userId == null || userId <= 0) {
      _errorMessage = 'يجب تسجيل الدخول لإرسال طلب رحلة';
      notifyListeners();
      return false;
    }

    if (!isPreferredTimeValid) {
      _errorMessage = 'أدخل الوقت بصيغة صحيحة (مثال 14:30)';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _customTripService.submitRequest(
        userId: userId,
        departurePoint: SyrianCities.toApiName(_fromCity!),
        arrivalPoint: SyrianCities.toApiName(_toCity!),
        date: _formatDateForApi(_preferredDate!),
        time: _formatTimeForApi(_preferredTime.trim()),
        notes: _notes.trim(),
      );
      resetForm();
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _formatTimeForApi(String time) {
    final match = _timeRegex.firstMatch(time)!;
    final hour = int.parse(match.group(1)!).toString().padLeft(2, '0');
    final minute = match.group(2)!;
    return '$hour:$minute:00';
  }
}
