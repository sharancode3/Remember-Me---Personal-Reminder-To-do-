import 'package:flutter/material.dart';

class TimelineAxisPainter extends CustomPainter {
  TimelineAxisPainter({required this.slotHeight});

  final double slotHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.24)
      ..strokeWidth = 1.2;
    final markerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..strokeWidth = 0.8;

    const leftPadding = 76.0;
    canvas.drawLine(const Offset(leftPadding, 0), Offset(leftPadding, size.height), axisPaint);

    for (int hour = 0; hour <= 24; hour++) {
      final y = hour * slotHeight;
      canvas.drawLine(Offset(leftPadding + 8, y), Offset(size.width, y), markerPaint);
      canvas.drawCircle(Offset(leftPadding, y), 2.4, axisPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TimelineAxisPainter oldDelegate) {
    return oldDelegate.slotHeight != slotHeight;
  }
}
