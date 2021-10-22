import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final int ownIndex;
  final int currentIndex;
  const Indicator({
    required this.ownIndex,
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: currentIndex == ownIndex ? AppTheme.turquoiseBlue : AppTheme.grey,
      child: const SizedBox(
        height: 4,
        width: 55,
      ),
    );
  }
}
