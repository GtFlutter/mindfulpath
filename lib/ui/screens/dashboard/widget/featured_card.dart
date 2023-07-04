import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:meditation_app/main.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'dart:ui' as ui;

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 209 * $style.scale,
      // height: 120 * $style.scale,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.5),
        ),
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryGradientColor,
            AppColors.secondaryGradientColor,
          ],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10 * $style.scale),
            child: Text(
              'Prevent Cancer',
              style: $style.text.font(mulishRegular400, sizePx: 12.5),
            ),
          ),
          Expanded(
            child: Center(
              child: ClipPath(
                clipper: DashboardCustomImageClipper($style.scale * 15),
                child: Container(
                  width: (209 * $style.scale) * 0.65,
                  height: double.infinity,
                  decoration: ShapeDecoration(
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://miro.medium.com/v2/resize:fit:4800/format:webp/1*DLOqGuzEnTEL2ZZE2doSJw.jpeg',
                      ),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0 * $style.scale),
                        topRight: Radius.circular(0 * $style.scale),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCustomImageClipper extends CustomClipper<Path> {
  final double radius;
  DashboardCustomImageClipper(this.radius);
  @override
  Path getClip(Size size) {
    var points = [
      Offset(size.width * 0.1, 0), // point p1
      Offset(0, size.height * 0.9), // point p2
      Offset(size.width * 0.1, size.height), // point p3
      Offset(size.width, size.height * 0.9) // point p4
    ];

    final path = Path()..addPolygon(points, false);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }
}

// Working Code
// class DashboardCustomImageClipper extends CustomClipper<Path> {
//   final double radius;
//   DashboardCustomImageClipper(this.radius);
//   @override
//   Path getClip(Size size) {
//     double minAngel = 0.05;
//     double maxAngle = 0.95;
//     double topLeftDown = 0.15;

//     final path = Path();

//     path.moveTo(radius, size.height * 0.12);
//     path.lineTo(size.width * maxAngle - radius, 0);
//     path.arcToPoint(
//       Offset(size.width * maxAngle, radius),
//       radius: Radius.circular(radius),
//     );
//     // Bottom right
//     path.lineTo(size.width, size.height);
//     // Bottom left
//     path.lineTo(size.width * minAngel, size.height);
//     // Top Right
//     path.lineTo(0, radius + size.height * 0.12);
//     path.arcToPoint(
//       Offset(radius, size.height * 0.12),
//       radius: Radius.circular(radius),
//     );
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//     // TODO: implement shouldReclip
//     throw UnimplementedError();
//   }
// }

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffFF0000).withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(
                size.width * -0.01018356, size.height * 0.1095854, size.width * 0.9390424, size.height * 1.454949),
            bottomRight: Radius.circular(size.width * 0.1271186),
            bottomLeft: Radius.circular(size.width * 0.1271186),
            topLeft: Radius.circular(size.width * 0.1271186),
            topRight: Radius.circular(size.width * 0.1271186)),
        paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
