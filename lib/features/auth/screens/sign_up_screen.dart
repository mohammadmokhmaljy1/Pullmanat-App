import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_google_button.dart';
import '../widgets/auth_logo_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

/// شاشة إنشاء حساب — Sign up.png + Validation Messages
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(AppTheme.splashOverlayStyle);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// هل النموذج صالح للإرسال؟
  bool get _isFormValid {
    return Validators.name(_nameController.text) == null &&
        Validators.email(_emailController.text) == null &&
        Validators.phone(_phoneController.text) == null &&
        Validators.password(_passwordController.text) == null &&
        _acceptedTerms;
  }

  /// إرسال طلب إنشاء حساب للـ API
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      _showError('يجب الموافقة على الشروط والأحكام');
      return;
    }

    final auth = context.read<AuthProvider>();
    auth.clearError();

    final success = await auth.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.home);
    } else {
      _showError(auth.errorMessage ?? 'فشل إنشاء الحساب');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('هذه الميزة ستتوفر قريباً')),
    );
  }

  /// إعادة بناء الشاشة عند تغيير أي حقل لتحديث حالة الزر
  void _onFieldChanged(String _) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.authBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const Center(child: AuthLogoHeader(height: 72)),
                  const SizedBox(height: 24),
                  const Text(
                    'إنشاء حساب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AuthTextField(
                    label: 'الاسم الكامل',
                    controller: _nameController,
                    hintText: 'ahmad',
                    validator: Validators.name,
                    onChanged: _onFieldChanged,
                  ),
                  AuthTextField(
                    label: 'البريد الالكتروني',
                    controller: _emailController,
                    hintText: 'ahmad@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                    onChanged: _onFieldChanged,
                  ),
                  AuthTextField(
                    label: 'رقم الهاتف',
                    controller: _phoneController,
                    hintText: '+963 987 654 321',
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                    onChanged: _onFieldChanged,
                  ),
                  AuthTextField(
                    label: 'كلمة المرور',
                    controller: _passwordController,
                    obscureText: true,
                    showVisibilityToggle: true,
                    validator: Validators.password,
                    onChanged: _onFieldChanged,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) {
                          setState(() => _acceptedTerms = value ?? false);
                        },
                        activeColor: AppColors.brandLightBlue,
                        checkColor: AppColors.white,
                        side: const BorderSide(color: AppColors.white, width: 1.5),
                      ),
                      const Expanded(
                        child: Text(
                          'أوافق على كل الشروط والأحكام',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AuthPrimaryButton(
                    label: 'إنشاء حساب',
                    isLoading: auth.isLoading,
                    enabled: _isFormValid,
                    onPressed: _handleRegister,
                  ),
                  const AuthDivider(),
                  AuthGoogleButton(onPressed: _showComingSoon),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.push(AppRoutes.signIn),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(text: 'هل لديك حساب مسبقاً؟ '),
                            TextSpan(
                              text: 'تسجيل دخول',
                              style: TextStyle(
                                color: AppColors.authLink,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
