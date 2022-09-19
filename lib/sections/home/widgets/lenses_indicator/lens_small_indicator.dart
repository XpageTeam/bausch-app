import 'package:bausch/help/help_functions.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LensSmallIndicator extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const LensSmallIndicator({
    required this.myLensesWM,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bothActive = myLensesWM.leftLensDate.value != null &&
        myLensesWM.rightLensDate.value != null;
    final activeDate =
        myLensesWM.leftLensDate.value ?? myLensesWM.rightLensDate.value;
    final isLeft = myLensesWM.leftLensDate.value != null;
    final percent = activeDate!.daysLeft >=
            myLensesWM.currentProduct.value!.lifeTime
        ? 0
        : activeDate.daysLeft < 0
            ? 1
            : 1 -
                activeDate.daysLeft / myLensesWM.currentProduct.value!.lifeTime;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: activeDate.daysLeft >= 0
          ? Column(
              children: [
                CircularPercentIndicator(
                  radius: 33,
                  animation: true,
                  animationDuration: 2000,
                  lineWidth: 10,
                  percent: percent.toDouble(),

                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: AppTheme.mystic,
                  // TODO(all): не получается сделать градиент,
                  // пока оставил один цвет
                  progressColor: bothActive
                      ? Colors.greenAccent
                      : isLeft
                          ? AppTheme.turquoiseBlue
                          : AppTheme.sulu,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  HelpFunctions.formatDateRu(
                    date: activeDate.dateEnd,
                    haveWeekDay: true,
                    haveTime: false,
                  ),
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
                  HelpFunctions.formatDateRu(
                    date: activeDate.dateEnd,
                    haveWeekDay: true,
                    haveTime: false,
                  ),
                  style: AppStyles.n1,
                ),
              ],
            ),
    );
  }
}
