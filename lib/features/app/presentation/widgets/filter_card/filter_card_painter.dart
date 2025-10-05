import 'package:flutter/material.dart';

class FilterCustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.02724796, size.height * 0.1383377);
    path.cubicTo(
        size.width * 0.02724796,
        size.height * 0.1114284,
        size.width * 0.03675804,
        size.height * 0.08947222,
        size.width * 0.04863433,
        size.height * 0.08896358);
    path.lineTo(size.width * 0.9505422, size.height * 0.05033401);
    path.cubicTo(
        size.width * 0.9627384,
        size.height * 0.04981154,
        size.width * 0.9727520,
        size.height * 0.07206914,
        size.width * 0.9727520,
        size.height * 0.09970802);
    path.lineTo(size.width * 0.9727520, size.height * 0.8765432);
    path.cubicTo(
        size.width * 0.9727520,
        size.height * 0.9038148,
        size.width * 0.9629918,
        size.height * 0.9259259,
        size.width * 0.9509537,
        size.height * 0.9259259);
    path.lineTo(size.width * 0.04904632, size.height * 0.9259259);
    path.cubicTo(
        size.width * 0.03700736,
        size.height * 0.9259259,
        size.width * 0.02724796,
        size.height * 0.9038148,
        size.width * 0.02724796,
        size.height * 0.8765432);
    path.lineTo(size.width * 0.02724796, size.height * 0.1383377);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class FilterCustomBorder extends CustomPainter {
  final Color borderColor;
  final double borderThickness;
  FilterCustomBorder({
    super.repaint,
    required this.borderColor,
    this.borderThickness = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = FilterCustomClip().getClip(size);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderThickness
      ..color = borderColor;

    canvas.drawPath(path_0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
