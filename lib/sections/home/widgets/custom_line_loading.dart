import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomLineLoadingIndicator extends StatelessWidget {
  final Duration animationDuration;
  final String text;
  late final int maxDays;
  late final int remainDays;

  CustomLineLoadingIndicator({
    required this.animationDuration,
    required this.text,
    required int maxDays,
    required int remainDays,
    Key? key,
  }) : super(key: key) {
    this.maxDays = maxDays > 0 ? maxDays : 1;
    this.remainDays =
        remainDays > maxDays ? maxDays : (remainDays < 0 ? 0 : remainDays);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: 26,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedContainer(
              curve: Curves.easeInOutCubic,
              duration: animationDuration,
              height: 26,
              width: constraints.maxWidth / maxDays * (maxDays - remainDays),
              decoration: BoxDecoration(
                color: AppTheme.sulu,
                borderRadius: BorderRadius.circular(5),
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppStyles.p1,
            ),
          ],
        ),
      ],
    );
  }
}
