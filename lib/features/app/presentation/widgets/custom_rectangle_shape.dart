import 'package:flutter/material.dart';

class NavCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.2375000, size.height * 0.2915000);
    path_0.cubicTo(
        size.width * 0.2375000,
        size.height * 0.2584835,
        size.width * 0.2625625,
        size.height * 0.2310139,
        size.width * 0.2950650,
        size.height * 0.2284063);
    path_0.lineTo(size.width * 0.6950650, size.height * 0.1963241);
    path_0.cubicTo(
        size.width * 0.7314150,
        size.height * 0.1934089,
        size.width * 0.7625000,
        size.height * 0.2224937,
        size.width * 0.7625000,
        size.height * 0.2594177);
    path_0.lineTo(size.width * 0.7625000, size.height * 0.6448734);
    path_0.cubicTo(
        size.width * 0.7625000,
        size.height * 0.6800544,
        size.width * 0.7341688,
        size.height * 0.7084835,
        size.width * 0.6994300,
        size.height * 0.7081620);
    path_0.lineTo(size.width * 0.2994300, size.height * 0.7044671);
    path_0.cubicTo(
        size.width * 0.2651362,
        size.height * 0.7041506,
        size.width * 0.2375000,
        size.height * 0.6759076,
        size.width * 0.2375000,
        size.height * 0.6411785);
    path_0.lineTo(size.width * 0.2375000, size.height * 0.2915000);
    path_0.close();

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02500000;
    paint0Stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.transparent;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
