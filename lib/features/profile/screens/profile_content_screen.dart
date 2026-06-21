import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/status_bar_region.dart';
import '../models/profile_content_section.dart';

/// شاشة عرض محتوى نصي — مساعدة، خصوصية، شروط
class ProfileContentScreen extends StatelessWidget {
  const ProfileContentScreen({
    super.key,
    required this.page,
  });

  final ProfileContentPage page;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StatusBarRegion.darkTop(
        child: Scaffold(
        backgroundColor: AppColors.homeBackground,
        appBar: AppBar(
          backgroundColor: AppColors.homeNavBar,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            page.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (page.intro != null) ...[
                _IntroCard(text: page.intro!),
                const SizedBox(height: 20),
              ],
              ...page.sections.map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _SectionCard(section: section),
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

/// بطاقة المقدمة — نص توضيحي في أعلى الصفحة
class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.homeNavBar.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.brandLightBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.7,
          color: Color(0xFF1A2F3D),
        ),
      ),
    );
  }
}

/// بطاقة قسم واحد — عنوان + فقرات أو نقاط
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final ProfileContentSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            section.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.authPrimaryButton,
            ),
          ),
          const SizedBox(height: 10),
          ...section.paragraphs.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                paragraph,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF3A4A55),
                ),
              ),
            ),
          ),
          ...section.bulletPoints.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Icon(
                      Icons.circle,
                      size: 6,
                      color: AppColors.brandLightBlue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.7,
                        color: Color(0xFF3A4A55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
