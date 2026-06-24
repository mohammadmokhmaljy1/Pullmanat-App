import '../../home/models/trip_model.dart';

/// أوقات الرحلة المعروضة — انطلاق، استراحة، وصول
class TripScheduleInfo {
  const TripScheduleInfo({
    required this.departure,
    required this.breakTime,
    required this.arrival,
  });

  final String departure;
  final String breakTime;
  final String arrival;

  /// حساب أوقات تقريبية من وقت انطلاق الرحلة
  factory TripScheduleInfo.fromTrip(TripModel trip) {
    final departure = _parseTime(trip.formattedTime);
    final breakTime = departure.add(const Duration(hours: 2));
    final arrival = departure.add(const Duration(hours: 4));
    return TripScheduleInfo(
      departure: _format12h(departure),
      breakTime: _format12h(breakTime),
      arrival: _format12h(arrival),
    );
  }

  static DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.tryParse(parts.first) ?? 10;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(2026, 1, 1, hour, minute);
  }

  static String _format12h(DateTime time) {
    var hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return '$hour:$minute$period';
  }
}
