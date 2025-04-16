import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

class BoatPainter extends CustomPainter {
  final double rudderAngle;
  final double sailAngle;

  BoatPainter({required this.rudderAngle, required this.sailAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final boatPaint = Paint()..color = Colors.teal;
    final rudderPaint = Paint()..color = Colors.red;
    final sailPaint = Paint()..color = Colors.black;

    // Draw boat hull as a triangle
    final hullWidth = 100.0;
    final hullHeight = 60.0;
    final path =
        Path()
          ..moveTo(center.dx, center.dy - hullHeight / 2) // top point
          ..lineTo(
            center.dx - hullWidth / 2,
            center.dy + hullHeight / 2,
          ) // bottom left
          ..lineTo(
            center.dx + hullWidth / 2,
            center.dy + hullHeight / 2,
          ) // bottom right
          ..close();
    canvas.drawPath(path, boatPaint);

    // Draw rudder
    final rudderLength = 30.0;
    final rudderEnd = Offset(
      center.dx + rudderLength * sin(rudderAngle * pi / 180),
      center.dy + hullHeight / 2 + rudderLength * cos(rudderAngle * pi / 180),
    );
    canvas.drawLine(center + Offset(0, hullHeight / 2), rudderEnd, rudderPaint);

    // Draw sail
    final sailHeight = 80.0;
    final sailTip = Offset(
      center.dx + sailHeight * sin((180 + sailAngle) * pi / 180),
      center.dy - sailHeight * cos((180 + sailAngle) * pi / 180),
    );
    canvas.drawLine(center, sailTip, sailPaint);
    canvas.drawCircle(sailTip, 5, sailPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
