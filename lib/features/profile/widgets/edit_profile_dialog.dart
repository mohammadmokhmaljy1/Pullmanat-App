import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../auth/models/user_model.dart';
import '../providers/profile_provider.dart';

/// نافذة تعديل بيانات المستخدم — مطابقة لتصميم Figma
class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({
    super.key,
    required this.user,
    required this.onSaved,
  });

  final UserModel user;
  final ValueChanged<UserModel> onSaved;

  static Future<void> show(
    BuildContext context, {
    required UserModel user,
    required ValueChanged<UserModel> onSaved,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => EditProfileDialog(
        user: user,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.displayPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// إرسال التحديث للـ API — البريد للعرض فقط لأن الـ API لا يدعم تعديله
  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = context.read<ProfileProvider>();
    profile.clearError();

    final updatedUser = await profile.updateProfile(
      userId: widget.user.userId,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      image: widget.user.image,
    );

    if (!mounted) return;

    if (updatedUser != null) {
      // دمج البريد المحلي إذا لم يُرجعه الـ API (update.php لا يعدّل البريد)
      final merged = updatedUser.email.isEmpty
          ? updatedUser.copyWith(email: widget.user.email)
          : updatedUser;
      widget.onSaved(merged);
      Navigator.of(context).pop();
      return;
    }

    final error = profile.errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.authError,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUpdating = context.watch<ProfileProvider>().isUpdating;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: BoxDecoration(
            color: AppColors.authBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: isUpdating
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.authError.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.authError,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                _EditField(
                  label: 'الاسم',
                  controller: _nameController,
                  validator: Validators.name,
                ),
                _EditField(
                  label: 'البريد الالكتروني',
                  controller: _emailController,
                  readOnly: true,
                  inputTextDirection: TextDirection.ltr,
                ),
                _EditField(
                  label: 'رقم الهاتف',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                  inputTextDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isUpdating ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.profileSaveButton,
                      disabledBackgroundColor:
                          AppColors.profileSaveButton.withValues(alpha: 0.5),
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: isUpdating
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Text(
                            'حفظ',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.label,
    required this.controller,
    this.validator,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.inputTextDirection = TextDirection.rtl,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final TextInputType keyboardType;
  final TextDirection inputTextDirection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            validator: validator,
            keyboardType: keyboardType,
            textDirection: inputTextDirection,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: readOnly
                  ? AppColors.authInputText.withValues(alpha: 0.7)
                  : AppColors.authInputText,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.authInputBackground,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
