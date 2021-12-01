import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final bool isActive;
  final Duration animationDuration;

  const Indicator({
    required this.isActive,
    required this.animationDuration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration,
      color: isActive ? AppTheme.turquoiseBlue : Colors.white,
      child: const SizedBox(
        height: 5,
        width: double.infinity,
      ),
    );
  }
}
