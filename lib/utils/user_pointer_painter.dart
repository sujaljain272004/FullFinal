import 'package:flutter/material.dart';
import 'dart:math' as math;

class UserPointerPainter extends CustomPainter {
  final double cx;
  final double cy;
  final double scaleX;
  final double scaleY;
  final double direction; // in radians
  final bool isNearWaypoint;
  final bool isOffRoute;

  UserPointerPainter(
    this.cx,
    this.cy,
    this.scaleX,
    this.scaleY,
    this.direction, {
    this.isNearWaypoint = false,
    this.isOffRoute = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = isOffRoute ? Colors.red : const Color.fromARGB(255, 199, 12, 177);

    // Create circle at the center point
    final center = Offset(cx * scaleX, cy * scaleY);
    final circleRadius = 8.0; // Adjust this value to change circle size
    
    canvas.drawCircle(center, circleRadius, paint);

    // Draw accuracy circle when off route
    if (isOffRoute) {
      canvas.drawCircle(
        center,
        circleRadius * 1.5,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.red
          ..strokeWidth = 2,
      );
    }

    // Draw waypoint indicator
    if (isNearWaypoint) {
      canvas.drawCircle(
        center,
        circleRadius * 1.2,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.green
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant UserPointerPainter oldDelegate) {
    return oldDelegate.cx != cx ||
        oldDelegate.cy != cy ||
        oldDelegate.direction != direction ||
        oldDelegate.isNearWaypoint != isNearWaypoint ||
        oldDelegate.isOffRoute != isOffRoute;
  }
}
