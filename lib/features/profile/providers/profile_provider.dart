import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../auth/models/user_model.dart';
import '../services/profile_service.dart';

/// مزود الملف الشخصي — جلب وتحديث بيانات المستخدم
class ProfileProvider extends ChangeNotifier {
  ProfileProvider({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService();

  final ProfileService _profileService;

  bool _isLoadingProfile = false;
  bool _isUpdating = false;
  String? _errorMessage;

  bool get isLoadingProfile => _isLoadingProfile;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// جلب أحدث بيانات المستخدم من الـ API
  Future<UserModel?> fetchProfile({required int userId}) async {
    _isLoadingProfile = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _profileService.fetchProfile(userId: userId);
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return null;
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  /// تحديث الاسم والهاتف عبر الـ API
  Future<UserModel?> updateProfile({
    required int userId,
    required String name,
    required String phone,
    String? image,
  }) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final parsedPhone = _profileService.parsePhone(phone);
      return await _profileService.updateProfile(
        userId: userId,
        name: name,
        phone: parsedPhone,
        image: image,
      );
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return null;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}
