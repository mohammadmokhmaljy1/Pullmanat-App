import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/company_model.dart';

/// بطاقة عرض شركة نقل واحدة
class CompanyCard extends StatelessWidget {
  const CompanyCard({
    super.key,
    required this.company,
  });

  final CompanyModel company;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CompanyIcon(isActive: company.isActive),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          company.companyName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A2F3D),
                          ),
                        ),
                      ),
                      _StatusChip(isActive: company.isActive),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.route_outlined,
                    label: 'الوجهات',
                    value: company.destinations,
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'الهاتف',
                    value: company.displayPhone,
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'البريد',
                    value: company.email,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyIcon extends StatelessWidget {
  const _CompanyIcon({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? AppColors.brandLightBlue.withValues(alpha: 0.15)
            : AppColors.homeSurface,
        border: Border.all(
          color: isActive
              ? AppColors.brandLightBlue.withValues(alpha: 0.4)
              : AppColors.homeTextSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: Icon(
        Icons.directions_bus_rounded,
        color: isActive
            ? AppColors.brandLightBlue
            : AppColors.homeTextSecondary.withValues(alpha: 0.6),
        size: 28,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.profileVerifiedBadge.withValues(alpha: 0.15)
            : AppColors.homeTextSecondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'نشطة' : 'غير نشطة',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isActive
              ? AppColors.profileVerifiedBadge
              : AppColors.homeTextSecondary,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.brandLightBlue),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.homeTextSecondary,
              ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
