import '../../bookings/models/booking_model.dart';
import '../../home/models/trip_model.dart';

/// بيانات التنقل لشاشة تفاصيل الرحلة
class TripDetailsArgs {
  const TripDetailsArgs({
    required this.trip,
    this.booking,
  });

  final TripModel trip;
  final BookingModel? booking;
}
