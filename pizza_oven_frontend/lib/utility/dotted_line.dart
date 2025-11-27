
import 'package:flutter/material.dart';

class DottedCurveLine extends CustomPainter {

  final double initialXPoint;
  final double initialYPoint;
  final double curveXPoint;
  final double curveYPoint;
  final double endXPoint;
  final double endYPoint;

  const DottedCurveLine({
    required this.initialXPoint,
    required this.initialYPoint,
    required this.curveXPoint,
    required this.curveYPoint,
    required this.endXPoint,
    required this.endYPoint,
    });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * initialXPoint, size.height * initialYPoint);
    path.quadraticBezierTo(
      size.width * curveXPoint,
      size.height * curveYPoint,
      size.width * endXPoint,
      size.height * endYPoint,
    );

    const dashWidth = 5.0, dashSpace = 5.0;
    double distance = 0.0;

    for (final pm in path.computeMetrics()) {
      while (distance < pm.length) {
        final extractPath = pm.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
