import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as math;

/*
  This is the main fractioned circle graph for illustrating the percent daily.
  We will draw an arc for each macro provided, and a second one on top to fill
  the percentage.

  Under the circle will be a dynamic list of macros with the name, and percent
  remaining in text details. This will act as the legend for the graph, and
  each item should be accompanied by the color it is describing.
 */

class CircleGraphWidget extends CustomPainter {

  /*
    This list contains a set of Tupple2 objects which each
    contain the name and color of the macro and 2 integers, the first of
    which being the percent daily for the macro, and the second
    being the daily progress.
   */
  List<Tuple2<Tuple2<String, Color>,Tuple2<int,int>>> macros;

  CircleGraphWidget({this.macros});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 35.0
      ..style = PaintingStyle.stroke;
    final Rect rect = Rect.fromLTWH(
        -150.0, 30.0, 300.0, 300.0);

    if (macros.isNotEmpty) {
      double lastDouble = 0.0;
      for (var macro in macros) {
        //Make it the right color(:
        paint.color = macro.item1.item2;
        //Draw the arc using the macro object and lastDouble
        double sweep = ((macro.item2.item1/100) * 360) - 2;
        canvas.drawArc(rect, math.radians(lastDouble), math.radians(sweep), false, paint);
        //Change the paint color and draw over that arc to fill in daily completion
        paint.color = Color(0xAAC4C4C4);
        double percent = ((macro.item2.item2/100) * sweep);
        canvas.drawArc(rect, math.radians(lastDouble), math.radians(percent), false, paint);
        paint.color = Colors.blue[500];
        //Assign a new value to lastDouble for the next arc
        lastDouble = sweep + lastDouble + 2;
      }
    } 
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}