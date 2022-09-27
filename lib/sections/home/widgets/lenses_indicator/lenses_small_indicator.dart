import 'package:bausch/help/help_functions.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LensesSmallIndicator extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const LensesSmallIndicator({
    required this.myLensesWM,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CircularPercentIndicator(
              radius: 33,
              animation: true,
              animationDuration: 2000,
              lineWidth: 10,
              percent:  myLensesWM.rightLensDate.value!.daysLeft < 0 || myLensesWM.rightLensDate.value!.daysLeft >=
                          myLensesWM.currentProduct.value!.lifeTime
                      ? 1
                      : myLensesWM.rightLensDate.value!.daysLeft /
                          myLensesWM.currentProduct.value!.lifeTime,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: AppTheme.mystic,
              center: myLensesWM.leftLensDate.value!.daysLeft <= 0
                  ? Container(
                      height: 38,
                      width: 38,
                      decoration: const BoxDecoration(
                        color: AppTheme.redNotice,
                        shape: BoxShape.circle,
                      ),
                    )
                  : CircularPercentIndicator(
                      radius: 19,
                      animation: true,
                      animationDuration: 2000,
                      lineWidth: 9,
                      percent: myLensesWM.leftLensDate.value!.daysLeft < 0 || myLensesWM.leftLensDate.value!.daysLeft >=
                              myLensesWM.currentProduct.value!.lifeTime
                          ? 1
                          : myLensesWM.leftLensDate.value!.daysLeft /
                              myLensesWM.currentProduct.value!.lifeTime,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: AppTheme.mystic,
                      progressColor: AppTheme.turquoiseBlue,
                    ),
              progressColor: myLensesWM.rightLensDate.value!.daysLeft > 0
                  ? AppTheme.sulu
                  : AppTheme.redNotice,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: myLensesWM.leftLensDate.value!.daysLeft > 0
                        ? AppTheme.turquoiseBlue
                        : AppTheme.redNotice,
                  ),
                  child: const Center(
                    child: Text('L', style: AppStyles.n1),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                HelpFunctions.formatDateRu(
                  date: myLensesWM.leftLensDate.value!.dateEnd,
                  haveWeekDay: true,
                  haveTime: false,
                ),
                style: AppStyles.n1,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: myLensesWM.rightLensDate.value!.daysLeft > 0
                        ? AppTheme.sulu
                        : AppTheme.redNotice,
                  ),
                  child: const Center(
                    child: Text('R', style: AppStyles.n1),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                HelpFunctions.formatDateRu(
                  date: myLensesWM.rightLensDate.value!.dateEnd,
                  haveWeekDay: true,
                  haveTime: false,
                ),
                style: AppStyles.n1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
