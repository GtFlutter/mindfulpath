// Working Code

import 'package:flutter/material.dart';

class DashboardCustomImageClipper extends CustomClipper<Path> {
  final double radius;
  DashboardCustomImageClipper(this.radius);
  @override
  Path getClip(Size size) {
    double minAngel = 0.05;
    double maxAngle = 0.95;
    double tiltDownLeftCorner = 0.10;

    final path = Path();

    path.moveTo(radius, size.height * tiltDownLeftCorner);
    path.lineTo(size.width * maxAngle - radius, 0);
    path.arcToPoint(
      Offset(size.width * maxAngle, radius),
      radius: Radius.circular(radius),
    );
    // Bottom right
    path.lineTo(size.width, size.height);
    // Bottom left
    path.lineTo(size.width * minAngel, size.height);
    // Top Right
    path.lineTo(0, radius + size.height * tiltDownLeftCorner);
    path.arcToPoint(
      Offset(radius, size.height * tiltDownLeftCorner),
      radius: Radius.circular(radius),
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ShadowPainter extends CustomPainter {
  final DashboardCustomImageClipper clipper;

  ShadowPainter(this.clipper);
  @override
  void paint(Canvas canvas, Size size) {
    final shadowPath = clipper.getClip(size).shift(const Offset(5.7, -8.4));

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);

    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
