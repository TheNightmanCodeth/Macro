import 'package:flutter/material.dart';
import 'dart:math';

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  })
      : super(listenable: controller);

  final PageController controller;
  final int itemCount;
  final ValueChanged<int> onPageSelected;
  final Color color;

  static const double _dotSize = 16.0;
  static const double _maxZoom = 2.0;
  static const double _dotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_maxZoom - 1.0) * selectedness;
    return Container(
      width: _dotSpacing,
      child: Center(
        child: InkWell(
          onTap: () => onPageSelected,
          child: Material(
            color: color,
            type: MaterialType.circle,
            child: Container(
              width: _dotSize * zoom,
              height: _dotSize * zoom,
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
