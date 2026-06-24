import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// شريط الحجز السفلي — زر احجز الان
class TripBookingFooter extends StatelessWidget {
  const TripBookingFooter({
    super.key,
    required this.isSubmitting,
    required this.onBook,
  });

  final bool isSubmitting;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : onBook,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.homeNavBar,
            disabledBackgroundColor: AppColors.authDisabledButton,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : const Text(
                  'احجز الان',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}

/// أزرار المستخدم المسجّل — إلغاء وتعديل
class TripRegisteredActions extends StatelessWidget {
  const TripRegisteredActions({
    super.key,
    required this.isSubmitting,
    required this.onCancel,
    required this.onEdit,
  });

  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bookingCancelled,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'إلغاء الحجز',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.authDisabledButton,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'تعديل الرحلة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
