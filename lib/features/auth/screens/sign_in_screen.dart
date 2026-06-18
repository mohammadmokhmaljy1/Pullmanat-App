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

/// شاشة تسجيل الدخول — Sign in.png
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(AppTheme.splashOverlayStyle);
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// إرسال طلب تسجيل الدخول للـ API
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    auth.clearError();

    final success = await auth.login(
      identifier: _identifierController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.home);
    } else {
      _showError(auth.errorMessage ?? 'فشل تسجيل الدخول');
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
                  const SizedBox(height: 8),
                  // شريط علوي: رجوع يسار + شعار يمين
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const AuthLogoHeader(height: 56),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'تسجيل دخول',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AuthTextField(
                    label: 'رقم الهاتف أو البريد الالكتروني:',
                    controller: _identifierController,
                    hintText: 'ahmad@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.loginIdentifier,
                  ),
                  AuthTextField(
                    label: 'كلمة المرور:',
                    controller: _passwordController,
                    obscureText: true,
                    showVisibilityToggle: true,
                    validator: Validators.password,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showComingSoon,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.white),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            'هل نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AuthPrimaryButton(
                    label: 'تسجيل الدخول',
                    isLoading: auth.isLoading,
                    onPressed: _handleLogin,
                  ),
                  const AuthDivider(),
                  AuthGoogleButton(onPressed: _showComingSoon),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.push(AppRoutes.signUp),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(text: 'ليس لديك حساب ؟ '),
                            TextSpan(
                              text: 'إنشاء حساب',
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
