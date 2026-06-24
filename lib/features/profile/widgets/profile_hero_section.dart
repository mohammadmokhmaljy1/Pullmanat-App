import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/models/user_model.dart';
import 'profile_info_card.dart';

/// القسم العلوي — رأس داكن + صورة المستخدم + بطاقة البيانات
class ProfileHeroSection extends StatelessWidget {
  const ProfileHeroSection({
    super.key,
    required this.user,
    required this.onEditPressed,
    required this.onLogout,
  });

  final UserModel user;
  final VoidCallback onEditPressed;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            _ProfileHeaderBackground(onLogout: onLogout),
            // نصف الصورة فوق خط الرأس ونصفها تحته — كما في Figma
            Positioned(bottom: -48, child: const ProfileAvatar()),
          ],
        ),
        // مساحة لنصف الصورة السفلي
        const SizedBox(height: 48),
        Transform.translate(
          offset: const Offset(0, -24),
          child: ProfileInfoCard(user: user, onEditPressed: onEditPressed),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// خلفية الرأس الداكنة — مع SafeArea وزر تسجيل الخروج
class _ProfileHeaderBackground extends StatelessWidget {
  const _ProfileHeaderBackground({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.homeNavBar,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/logo_light.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  IconButton(
                    onPressed: onLogout,
                    tooltip: 'تسجيل الخروج',
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'حسابي',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
