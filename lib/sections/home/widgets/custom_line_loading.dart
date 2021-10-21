import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomLineLoadingIndicator extends StatelessWidget {
  final Duration animationDuration;
  final int maxDays;
  final int remainDays;

  const CustomLineLoadingIndicator({
    required this.animationDuration,
    required this.maxDays,
    required this.remainDays,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (remainDays > maxDays) {
      throw Exception(
        'Количество оставшихся дней не может быть больше максимального числа дней',
      );
    }
    if (remainDays < 0) {
      throw Exception(
        'Количество оставшихся дней не может быть меньше нуля',
      );
    }

    final currentWidth =
        (MediaQuery.of(context).size.width - StaticData.sidePadding * 2) /
            maxDays *
            (maxDays - remainDays);

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
          width: currentWidth, //snapshot.hasData ? currentWidth : 0,
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
