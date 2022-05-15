import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/theme.dart';

class TasbihBud extends StatelessWidget {
  const TasbihBud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final budSize = context.contentPanelWidth * 0.05;
    return Center(
        child: CustomPaint(
          painter: DrawCircle(budSize: budSize),
      ),
    );
  }
}


class DrawCircle extends CustomPainter {
  final double budSize;
  DrawCircle({required this.budSize});
  var paint2 = Paint()..shader = getOnBackgroundGradient().createShader(const Rect.fromLTWH(0.0, 0.0, 50.0, 40.0));
  // ..strokeWidth = 16
  // ..style = PaintingStyle.stroke;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(const Offset(0.0, 0.0), budSize, paint2);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}