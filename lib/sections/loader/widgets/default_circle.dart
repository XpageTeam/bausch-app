import 'package:flutter/material.dart';

class DefaultCircle extends StatelessWidget {
  final Color color;
  final double diameter;
  const DefaultCircle({
    this.color = Colors.white,
    this.diameter = 33,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
