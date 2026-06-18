import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'auth_field_label_row.dart';

/// حقل إدخال موحّد لشاشات تسجيل الدخول وإنشاء الحساب
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.showVisibilityToggle = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool showVisibilityToggle;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  String? _errorText;
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  /// التحقق من الحقل وعرض رسالة الخطأ
  String? _validate(String? value) {
    final error = widget.validator?.call(value);
    setState(() => _errorText = error);
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthFieldLabelRow(
          label: widget.label,
          errorText: _errorText,
        ),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText && _obscured,
          validator: _validate,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          onChanged: (value) {
            if (_errorText != null) {
              setState(() => _errorText = widget.validator?.call(value));
            }
            widget.onChanged?.call(value);
          },
          style: const TextStyle(
            color: AppColors.authInputText,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.authInputText.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: AppColors.authInputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.authError : Colors.transparent,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.authError : AppColors.brandLightBlue,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.authError, width: 1.5),
            ),
            prefixIcon: widget.showVisibilityToggle
                ? IconButton(
                    onPressed: () => setState(() => _obscured = !_obscured),
                    icon: Icon(
                      _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.brandLightBlue,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
