import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';

/// تغليف الشاشة للتحكم في لون أيقونات شريط الحالة عبر AnnotatedRegion
class StatusBarRegion extends StatelessWidget {
  const StatusBarRegion({
    super.key,
    required this.overlayStyle,
    required this.child,
  });

  final SystemUiOverlayStyle overlayStyle;
  final Widget child;

  /// أيقونات بيضاء — للشاشات ذات خلفية داكنة في الأعلى
  factory StatusBarRegion.darkTop({required Widget child}) {
    return StatusBarRegion(
      overlayStyle: AppTheme.overlayLightIcons,
      child: child,
    );
  }

  /// أيقونات سوداء — للشاشات ذات خلفية فاتحة في الأعلى
  factory StatusBarRegion.lightTop({required Widget child}) {
    return StatusBarRegion(
      overlayStyle: AppTheme.overlayDarkIcons,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: child,
    );
  }
}
