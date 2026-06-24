import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';

/// نافذة إدخال الرقم الوطني قبل الحجز
class BookTripDialog extends StatefulWidget {
  const BookTripDialog({super.key});

  static Future<int?> show(BuildContext context) {
    return showDialog<int>(
      context: context,
      builder: (context) => const BookTripDialog(),
    );
  }

  @override
  State<BookTripDialog> createState() => _BookTripDialogState();
}

class _BookTripDialogState extends State<BookTripDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'تأكيد الحجز',
          style: TextStyle(
            color: AppColors.homeNavBar,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              labelText: 'الرقم الوطني',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().length < 5) {
                return 'أدخل رقماً وطنياً صحيحاً';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              Navigator.pop(context, int.parse(_controller.text.trim()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.homeNavBar,
              foregroundColor: AppColors.white,
            ),
            child: const Text('احجز'),
          ),
        ],
      ),
    );
  }
}

/// نافذة تعديل الحجز
class EditBookingDialog extends StatefulWidget {
  const EditBookingDialog({
    super.key,
    required this.initialNationalId,
    required this.initialNotes,
  });

  final int initialNationalId;
  final String initialNotes;

  static Future<({int nationalId, String notes})?> show(
    BuildContext context, {
    required int initialNationalId,
    required String initialNotes,
  }) {
    return showDialog<({int nationalId, String notes})>(
      context: context,
      builder: (context) => EditBookingDialog(
        initialNationalId: initialNationalId,
        initialNotes: initialNotes,
      ),
    );
  }

  @override
  State<EditBookingDialog> createState() => _EditBookingDialogState();
}

class _EditBookingDialogState extends State<EditBookingDialog> {
  late final TextEditingController _nationalIdController;
  late final TextEditingController _notesController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nationalIdController = TextEditingController(
      text: widget.initialNationalId.toString(),
    );
    _notesController = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'تعديل الرحلة',
          style: TextStyle(
            color: AppColors.homeNavBar,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nationalIdController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: 'الرقم الوطني',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (v) =>
                    (v ?? '').length < 5 ? 'أدخل رقماً وطنياً صحيحاً' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'ملاحظات',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              Navigator.pop(
                context,
                (
                  nationalId: int.parse(_nationalIdController.text),
                  notes: _notesController.text.trim(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.homeNavBar,
              foregroundColor: AppColors.white,
            ),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
