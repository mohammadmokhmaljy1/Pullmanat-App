import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/trip_details/models/trip_details_args.dart';
import '../../../features/trip_details/screens/trip_details_screen.dart';
import '../models/booking_filter.dart';
import '../models/booking_model.dart';

/// بطاقة حجز واحدة — My bookings.png
class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  Color _statusColor(BookingDisplayStatus status) {
    switch (status) {
      case BookingDisplayStatus.upcoming:
        return AppColors.bookingUpcoming;
      case BookingDisplayStatus.completed:
        return AppColors.bookingCompleted;
      case BookingDisplayStatus.cancelled:
        return AppColors.bookingCancelled;
      case BookingDisplayStatus.unknown:
        return AppColors.homeTextSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = booking.displayStatus;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(status).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(status),
                  ),
                ),
              ),
              const Spacer(),
              _BusBadge(),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _RouteRow(
                  from: booking.fromCity,
                  to: booking.toCity,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 16,
                color: AppColors.brandLightBlue,
              ),
              const SizedBox(width: 4),
              Text(
                booking.formattedTime,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.homeTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.seatLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.homeNavBar,
                  ),
                ),
              ),
              Text(
                booking.formattedPrice,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.homeNavBar,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: AppColors.homeDetailsButton,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () {
                  if (booking.trip == null) return;
                  openTripDetails(
                    context,
                    TripDetailsArgs(
                      trip: booking.trip!,
                      booking: booking,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Text(
                    'التفاصيل',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BusBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.homeSurface,
            border: Border.all(
              color: AppColors.brandLightBlue.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            Icons.directions_bus_rounded,
            color: AppColors.brandLightBlue.withValues(alpha: 0.9),
            size: 28,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'LUXURY',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.brandLightBlue.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.from,
    required this.to,
  });

  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 18,
          color: AppColors.brandLightBlue,
        ),
        const SizedBox(width: 4),
        Text(
          from,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.homeNavBar,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.arrow_back_rounded,
            size: 18,
            color: AppColors.homeTextSecondary.withValues(alpha: 0.7),
          ),
        ),
        Text(
          to,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.homeNavBar,
          ),
        ),
      ],
    );
  }
}
