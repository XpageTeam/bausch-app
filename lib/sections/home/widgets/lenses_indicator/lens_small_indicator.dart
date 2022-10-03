import 'dart:math';

import 'package:bausch/help/help_functions.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LensSmallIndicator extends StatelessWidget {
  final MyLensesWM myLensesWM;
  final bool sameTime;
  const LensSmallIndicator({
    required this.myLensesWM,
    required this.sameTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeDate =
        myLensesWM.leftLensDate.value ?? myLensesWM.rightLensDate.value;
    final isLeft = myLensesWM.leftLensDate.value != null;
    final percent =
        activeDate!.daysLeft >= myLensesWM.currentProduct.value!.lifeTime
            ? 1
            : activeDate.daysLeft / myLensesWM.currentProduct.value!.lifeTime;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: activeDate.daysLeft > 0
          ? Column(
              children: [
                CircularPercentIndicator(
                  radius: 33,
                  animation: true,
                  animationDuration: 2000,
                  lineWidth: 10,
                  percent: percent.toDouble(),
                  linearGradient: sameTime
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          transform: GradientRotation(-2 * pi / 3),
                          colors: [
                            AppTheme.sulu,
                            AppTheme.turquoiseBlue,
                          ],
                        )
                      : null,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: AppTheme.mystic,
                  progressColor: sameTime
                      ? null
                      : isLeft
                          ? AppTheme.turquoiseBlue
                          : AppTheme.sulu,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${HelpFunctions.weekday(activeDate.dateEnd.day)}, ${activeDate.dateEnd.day} ${HelpFunctions.getMonthNameByNumber(activeDate.dateEnd.month)}',
                  style: AppStyles.n1,
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 66,
                  width: 66,
                  decoration: const BoxDecoration(
                    color: AppTheme.redNotice,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/icons/loading.png',
                    scale: 3,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${HelpFunctions.weekday(activeDate.dateEnd.day)}, ${activeDate.dateEnd.day} ${HelpFunctions.getMonthNameByNumber(activeDate.dateEnd.month)}',
                  style: AppStyles.n1,
                ),
              ],
            ),
    );
  }
}
