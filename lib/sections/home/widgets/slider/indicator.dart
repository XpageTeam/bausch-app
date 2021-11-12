import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final int ownIndex;
  final int currentIndex;
  final double rightMargin;
  final double indicatorWidth;
  final VoidCallback? onPressed;
  final Duration animationDuration;

  const Indicator({
    required this.ownIndex,
    required this.currentIndex,
    required this.indicatorWidth,
    required this.rightMargin,
    required this.animationDuration,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: rightMargin),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: AnimatedContainer(
            duration: animationDuration,
            color: currentIndex == ownIndex
                ? AppTheme.turquoiseBlue
                : Colors.white,
            child: SizedBox(
              height: 4,
              width: indicatorWidth,
            ),
          ),
        ),
      ),
    );
  }
}
