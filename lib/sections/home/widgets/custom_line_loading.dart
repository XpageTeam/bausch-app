import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomLineLoadingIndicator extends StatelessWidget {
  final Duration animationDuration;
  final AsyncSnapshot<double> snapshot;
  const CustomLineLoadingIndicator({
    required this.animationDuration,
    required this.snapshot,
    Key? key,
  }) : super(key: key);

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
          width: snapshot.hasData ? snapshot.data! : 100,
          decoration: BoxDecoration(
            color: AppTheme.sulu,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '130 баллов сгорят через 10 дней',
              style: AppStyles.p1,
            ),
          ],
        ),
      ],
    );
  }
}
