import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// أيقونة Google المبسّطة
class GoogleIcon extends StatelessWidget {
  const GoogleIcon({super.key, this.size = 22});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleIconPainter(),
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final blue = Paint()..color = const Color(0xFF4285F4);
    final red = Paint()..color = const Color(0xFFEA4335);
    final yellow = Paint()..color = const Color(0xFFFBBC05);
    final green = Paint()..color = const Color(0xFF34A853);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5, 3.5, true, blue,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.6, 2.0, true, green,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.8, 1.8, true, yellow,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.5, 2.0, true, red,
    );

    final hole = Paint()..color = AppColors.authBackground;
    canvas.drawCircle(center, radius * 0.55, hole);
    canvas.drawRect(
      Rect.fromLTWH(center.dx, center.dy - radius * 0.15, radius, radius * 0.3),
      blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
