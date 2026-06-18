/// ثوابت نقاط النهاية (Endpoints) للـ API
class ApiEndpoints {
  ApiEndpoints._();

  /// عنوان الخادم — يجب أن يطابق baseUrl في postman_collections.json
  static const String baseUrl =
      'https://wheat-magpie-215255.hostingersite.com';

  static const String userLogin = '/users/login.php';
  static const String userCreate = '/users/create.php';
  static const String userProfile = '/users/index.php';
}
