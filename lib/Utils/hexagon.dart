// import 'package:flutter/material.dart';
// import 'dart:math' as math;
//
// class HexagonPainter extends CustomPainter {
//   static const int sideOfHexagon = 6;
//   late final double radius;
//   late final Offset center;
//   late final Color color;
//
//   HexagonPainter(this.center, this.radius,this.color);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = color;
//     Path path = createHexagonPath();
//     canvas.drawPath(path, paint);
//   }
//
//   Path createHexagonPath() {
//     final path = Path();
//     var angle = (math.pi * 2) / sideOfHexagon;
//     Offset firsPoint = Offset(radius * math.cos(0.0), radius * math.sin(0.0));
//     path.moveTo(firsPoint.dx + center.dx, firsPoint.dy + center.dy);
//     for (int i = 1; i < sideOfHexagon; i++) {
//       double x = radius * math.cos((angle * i) + center.dx);
//       double y = radius * math.sin((angle * i) + center.dy);
//       path.lineTo(x, y);
//     }
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
