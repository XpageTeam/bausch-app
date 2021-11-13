import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomLineLoadingIndicator extends StatelessWidget {
  final Duration animationDuration;
  final String text;
  late int maxDays;
  late int remainDays;

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
        AnimatedContainer(
          curve: Curves.easeInOutCubic,
          duration: animationDuration,
          height: 26,
          width: _calcCurrentWidth(
            MediaQuery.of(context).size.width,
          ), //snapshot.hasData ? currentWidth : 0,
          decoration: BoxDecoration(
            color: AppTheme.sulu,
            borderRadius: BorderRadius.circular(5),
          ),
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

  double _calcCurrentWidth(
    double maxWidth,
  ) {
    return (maxWidth - StaticData.sidePadding * 2) /
        maxDays *
        (maxDays - remainDays);
  }
}
