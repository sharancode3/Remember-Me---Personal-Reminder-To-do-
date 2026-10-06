import 'dart:math' as math;
import 'package:flutter/material.dart';

class NeoBandaidAlarmLogo extends StatelessWidget {
  const NeoBandaidAlarmLogo({
    super.key,
    this.size = 32,
    this.alarmColor = const Color(0xFFFFD93D),
    this.bandaidColor = const Color(0xFFFF6B6B),
    this.borderColor = const Color(0xFF000000),
  });

  final double size;
  final Color alarmColor;
  final Color bandaidColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _NeoBandaidAlarmPainter(
        alarmColor: alarmColor,
        bandaidColor: bandaidColor,
        borderColor: borderColor,
      ),
    );
  }
}

class _NeoBandaidAlarmPainter extends CustomPainter {
  _NeoBandaidAlarmPainter({
    required this.alarmColor,
    required this.bandaidColor,
    required this.borderColor,
  });

  final Color alarmColor;
  final Color bandaidColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.08;
    final w = size.width;
    final h = size.height;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final crackPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.65
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    final alarmFill = Paint()
      ..color = alarmColor
      ..style = PaintingStyle.fill;

    final bandaidFill = Paint()
      ..color = bandaidColor
      ..style = PaintingStyle.fill;

    // 1. Hard Shadow of Alarm Face
    final center = Offset(w * 0.5, h * 0.55);
    final radius = w * 0.36;
    canvas.drawCircle(center + const Offset(2.5, 2.5), radius, shadowPaint);

    // 2. Bell Ears
    // Left Bell
    final leftBellCenter = Offset(w * 0.22, h * 0.24);
    canvas.drawCircle(leftBellCenter, w * 0.13, alarmFill);
    canvas.drawCircle(leftBellCenter, w * 0.13, borderPaint);

    // Right Bell
    final rightBellCenter = Offset(w * 0.78, h * 0.24);
    canvas.drawCircle(rightBellCenter, w * 0.13, alarmFill);
    canvas.drawCircle(rightBellCenter, w * 0.13, borderPaint);

    // Top Hammer
    final handlePath = Path()
      ..moveTo(w * 0.42, h * 0.18)
      ..lineTo(w * 0.58, h * 0.18);
    canvas.drawPath(handlePath, borderPaint);

    // 3. Legs
    final leftLeg = Path()
      ..moveTo(w * 0.28, h * 0.85)
      ..lineTo(w * 0.18, h * 0.95);
    canvas.drawPath(leftLeg, borderPaint);

    final rightLeg = Path()
      ..moveTo(w * 0.72, h * 0.85)
      ..lineTo(w * 0.82, h * 0.95);
    canvas.drawPath(rightLeg, borderPaint);

    // 4. Alarm Body
    canvas.drawCircle(center, radius, alarmFill);
    canvas.drawCircle(center, radius, borderPaint);

    // 5. CRACK LINES across the clock glass face
    final crack1 = Path()
      ..moveTo(center.dx - radius * 0.6, center.dy - radius * 0.5)
      ..lineTo(center.dx - radius * 0.1, center.dy - radius * 0.2)
      ..lineTo(center.dx + radius * 0.3, center.dy - radius * 0.35)
      ..lineTo(center.dx + radius * 0.7, center.dy - radius * 0.6);
    canvas.drawPath(crack1, crackPaint);

    final crack2 = Path()
      ..moveTo(center.dx - radius * 0.1, center.dy - radius * 0.2)
      ..lineTo(center.dx + radius * 0.1, center.dy + radius * 0.2)
      ..lineTo(center.dx - radius * 0.3, center.dy + radius * 0.6);
    canvas.drawPath(crack2, crackPaint);

    // 6. Clock Hands
    final handPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.9
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, Offset(center.dx, center.dy - radius * 0.55), handPaint);
    canvas.drawLine(center, Offset(center.dx + radius * 0.45, center.dy), handPaint);

    // 7. The Bandaid / Bandage placed directly OVER the cracks to heal the clock!
    canvas.save();
    canvas.translate(center.dx + radius * 0.05, center.dy - radius * 0.15);
    canvas.rotate(-math.pi / 5);

    final bandaidRect = Rect.fromCenter(
      center: Offset.zero,
      width: radius * 1.25,
      height: radius * 0.46,
    );
    final bandaidRRect = RRect.fromRectAndRadius(bandaidRect, Radius.circular(radius * 0.15));

    // Bandaid Shadow
    canvas.drawRRect(bandaidRRect.shift(const Offset(2.0, 2.0)), shadowPaint);
    // Bandaid Body
    canvas.drawRRect(bandaidRRect, bandaidFill);
    canvas.drawRRect(bandaidRRect, borderPaint);

    // Bandaid Center Pad
    final centerPadRect = Rect.fromCenter(
      center: Offset.zero,
      width: radius * 0.45,
      height: radius * 0.34,
    );
    final padPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawRect(centerPadRect, padPaint);

    // Bandaid Breathable Dots
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    for (double i = -radius * 0.42; i <= radius * 0.42; i += radius * 0.28) {
      if (i.abs() > radius * 0.2) {
        canvas.drawCircle(Offset(i, -radius * 0.08), radius * 0.04, dotPaint);
        canvas.drawCircle(Offset(i, radius * 0.08), radius * 0.04, dotPaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NeoBandaidAlarmPainter oldDelegate) {
    return oldDelegate.alarmColor != alarmColor ||
        oldDelegate.bandaidColor != bandaidColor ||
        oldDelegate.borderColor != borderColor;
  }
}
