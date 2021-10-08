import 'package:bausch/sections/loader/widgets/default_circle.dart';
import 'package:flutter/material.dart';

class MovingDefaultCircle extends StatelessWidget {
  final AnimationController controller;
  final double xOffsetValue;
  final Color? color;
  final double? diameter;
  const MovingDefaultCircle({
    required this.controller,
    required this.xOffsetValue,
    this.color,
    this.diameter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Transform.translate(
        offset: Offset(xOffsetValue, 0),
        child: DefaultCircle(
          color: color,
          diameter: diameter,
        ),
      ),
    );
  }
}
