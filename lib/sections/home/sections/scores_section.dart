import 'dart:math' as math;

import 'package:bausch/sections/home/widgets/custom_line_loading.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/point_widget.dart';
import 'package:bausch/widgets/text/underlined_text.dart';
import 'package:flutter/material.dart';

class ScoresSection extends StatelessWidget {
  final Duration loadingAnimationDuration;
  final Duration delay;

  const ScoresSection({
    required this.loadingAnimationDuration,
    required this.delay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '5600',
              style: TextStyle(
                leadingDistribution: TextLeadingDistribution
                    .even, // центрирует текст в строке по вертикали
                color: AppTheme.mineShaft,
                fontWeight: FontWeight.w500,
                fontSize: 85,
                height: 80 / 85,
                // height: 80 / 85,
              ),
            ),
            PointWidget(
              radius: 37 / 2,
              textStyle: TextStyle(
                leadingDistribution: TextLeadingDistribution.even,
                color: AppTheme.mineShaft,
                fontWeight: FontWeight.w500,
                fontSize: 27,
                height: 25 / 27,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        // UnderlinedText(
        //   space: 4,
        //   text:
        //       'Подчеркнутый текст (CustomPainter) и невероятные приключения какого-то неинтересного персонажа, '
        //       'а также его верного товарища - Кента, который поменял саперную лопату на тушенку во время второй мировой войны.',
        //   textStyle: AppStyles.p1.copyWith(
        //     fontSize: 24,
        //   ),
        //   lineWidth: 2,
        //   lineColor: AppTheme.turquoiseBlue,
        // ),
        FutureBuilder<int>(
          future: Future<int>.delayed(
            delay,
            () => 4,
          ),
          builder: (context, snapshot) {
            return CustomLineLoadingIndicator(
              text: '127 баллов сгорят через 5 дней',
              maxDays: 15,
              remainDays: snapshot.hasData
                  ? snapshot.data!
                  : 5, // 20 = maxDays - future.value
              animationDuration: loadingAnimationDuration,
            );
          },
        ),
      ],
    );
  }
}
