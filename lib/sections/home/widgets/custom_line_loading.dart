import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomLineLoadingIndicator extends StatelessWidget {
  final Duration animationDuration;
  final String text;
  late final int maxDays;
  late final int daysRemain;

  CustomLineLoadingIndicator({
    required this.animationDuration,
    required this.text,
    required int maxDays,
    required int daysRemain,
    Key? key,
  }) : super(key: key) {
    this.maxDays = maxDays > 0 ? maxDays : 1;
    this.daysRemain =
        daysRemain > maxDays ? maxDays : (daysRemain < 0 ? 0 : daysRemain);
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
              width: constraints.maxWidth / maxDays * (maxDays - daysRemain),
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
