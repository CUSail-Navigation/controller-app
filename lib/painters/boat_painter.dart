import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

class BoatPainter extends CustomPainter {
  final double rudderAngle;
  final double sailAngle;
  final double windAngle;
  final double heading;

  BoatPainter({
    required this.rudderAngle,
    required this.sailAngle,
    this.windAngle = 0.0,  // Default to 0 if not provided
    this.heading = 0.0,    // Default to 0 if not provided
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final boatPaint = Paint()..color = Colors.red;
    final rudderPaint = Paint()..color = Colors.redAccent;
    final sailPaint = Paint()..color = Colors.black;

    // Draw boat hull as a triangle
    final hullWidth = 50.0;
    final hullHeight = 100.0;
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
      canvas.drawCircle(rudderEnd, 3, rudderPaint);


    // Draw sail
    final sailHeight = 80.0;
    final sailTip = Offset(
      center.dx + sailHeight * sin((180 + sailAngle) * pi / 180),
      center.dy - sailHeight * cos((180 + sailAngle) * pi / 180),
    );
    canvas.drawLine(center, sailTip, sailPaint);
    canvas.drawCircle(sailTip, 5, sailPaint);

    drawWindArrow(canvas, size);
  }

  void drawWindArrow(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final arrowLength = size.width * 0.25;  // Length of the wind arrow
    final arrowHeadSize = size.width * 0.05; // Size of arrow head
    
    // Convert angle to radians for drawing
    // Note: In Flutter's coordinate system, 0 radians is to the right (east) and rotation is clockwise
    final angleInRadians = (windAngle * pi) / 180;
    
    // Calculate end point of arrow
    final endX = center.dx + arrowLength * cos(angleInRadians);
    final endY = center.dy + arrowLength * sin(angleInRadians);
    final endPoint = Offset(endX, endY);
    
    // Create a paint object for the arrow
    final arrowPaint = Paint()
      ..color = Colors.blue  // Wind is typically shown in blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    
    // Draw the line of the arrow
    canvas.drawLine(center, endPoint, arrowPaint);
    
    // Draw the arrowhead
    final headAngle = atan2(endY - center.dy, endX - center.dx);
    
    final headPoint1X = endX - arrowHeadSize * cos(headAngle - pi/6);
    final headPoint1Y = endY - arrowHeadSize * sin(headAngle - pi/6);
    final headPoint1 = Offset(headPoint1X, headPoint1Y);
    
    final headPoint2X = endX - arrowHeadSize * cos(headAngle + pi/6);
    final headPoint2Y = endY - arrowHeadSize * sin(headAngle + pi/6);
    final headPoint2 = Offset(headPoint2X, headPoint2Y);
    
    // Create a path for the arrowhead
    final arrowHeadPath = Path()
      ..moveTo(endX, endY)
      ..lineTo(headPoint1X, headPoint1Y)
      ..lineTo(headPoint2X, headPoint2Y)
      ..close();
    
    final arrowHeadPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(arrowHeadPath, arrowHeadPaint);
    
    // Optionally add a label for the wind
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Wind',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset(endX + 5, endY - textPainter.height / 2)
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
