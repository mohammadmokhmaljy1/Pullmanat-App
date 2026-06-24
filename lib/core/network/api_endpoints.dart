/// ثوابت نقاط النهاية (Endpoints) للـ API
class ApiEndpoints {
  ApiEndpoints._();

  /// عنوان الخادم — يجب أن يطابق baseUrl في postman_collections.json
  static const String baseUrl =
      'https://wheat-magpie-215255.hostingersite.com';

  static const String userLogin = '/users/login.php';
  static const String userCreate = '/users/create.php';
  static const String userProfile = '/users/index.php';
  static const String userUpdate = '/users/update.php';

  static const String tripsView = '/trips/view.php';
  static const String tripsSearch = '/trips/index.php';
  static const String departurePoints = '/departure_points/index.php';
  static const String companiesList = '/company/index.php';
  static const String specialRequestsCreate = '/special_requests/index.php';
  static const String reservationsByUser = '/reservations/index.php';
  static const String reservationsAdd = '/reservations/add.php';
  static const String reservationsUpdate = '/reservations/update.php';
  static const String reservationsCancel = '/reservations/status.php';
}
