import 'package:flutter/material.dart';
import 'dart:math' as math;

class ReturnRoutePainter extends CustomPainter {
  final double userX;
  final double userY;
  final double targetX;
  final double targetY;
  final double scaleX;
  final double scaleY;

  ReturnRoutePainter(
    this.userX,
    this.userY,
    this.targetX,
    this.targetY,
    this.scaleX,
    this.scaleY,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw dashed line from user to nearest route point
    final path = Path();
    path.moveTo(userX * scaleX, userY * scaleY);
    path.lineTo(targetX * scaleX, targetY * scaleY);

    // Create dash effect
    final dashPath = Path();
    final distance = _calculateDistance(
      userX * scaleX,
      userY * scaleY,
      targetX * scaleX,
      targetY * scaleY,
    );
    const dashLength = 10.0;
    const gapLength = 5.0;
    double drawn = 0.0;

    while (drawn < distance) {
      final remaining = distance - drawn;
      final toDraw = math.min(dashLength, remaining);
      final start = drawn / distance;
      final end = (drawn + toDraw) / distance;

      dashPath.moveTo(
        _lerp(userX * scaleX, targetX * scaleX, start),
        _lerp(userY * scaleY, targetY * scaleY, start),
      );
      dashPath.lineTo(
        _lerp(userX * scaleX, targetX * scaleX, end),
        _lerp(userY * scaleY, targetY * scaleY, end),
      );

      drawn += toDraw + gapLength;
    }

    canvas.drawPath(dashPath, paint);

    // Draw arrow at target point
    _drawArrow(
      canvas,
      Offset(targetX * scaleX, targetY * scaleY),
      Offset(userX * scaleX, userY * scaleY),
      paint,
    );
  }

  double _calculateDistance(double x1, double y1, double x2, double y2) {
    return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2));
  }

  double _lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }

  void _drawArrow(Canvas canvas, Offset tip, Offset from, Paint paint) {
    const arrowLength = 20.0;
    const arrowAngle = 25.0 * math.pi / 180.0;

    final dx = tip.dx - from.dx;
    final dy = tip.dy - from.dy;
    final angle = math.atan2(dy, dx);

    final path = Path();
    path.moveTo(
      tip.dx - arrowLength * math.cos(angle - arrowAngle),
      tip.dy - arrowLength * math.sin(angle - arrowAngle),
    );
    path.lineTo(tip.dx, tip.dy);
    path.lineTo(
      tip.dx - arrowLength * math.cos(angle + arrowAngle),
      tip.dy - arrowLength * math.sin(angle + arrowAngle),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ReturnRoutePainter oldDelegate) {
    return oldDelegate.userX != userX ||
        oldDelegate.userY != userY ||
        oldDelegate.targetX != targetX ||
        oldDelegate.targetY != targetY;
  }
}
