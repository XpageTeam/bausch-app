import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_date_sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class MyLensesContainer extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const MyLensesContainer({required this.myLensesWM, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamedStateBuilder<LensDateModel?>(
      streamedState: myLensesWM.leftLensDate,
      builder: (_, leftLensDate) => StreamedStateBuilder<LensDateModel?>(
        streamedState: myLensesWM.rightLensDate,
        builder: (_, rightLensDate) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          child: WhiteContainerWithRoundedCorners(
            onTap: () {
              if (myLensesWM.lensesPairModel.value != null) {
                Keys.mainContentNav.currentState!
                    .pushNamed('/my_lenses', arguments: [myLensesWM]);
              } else {
                Keys.mainContentNav.currentState!.pushNamed('/choose_lenses');
              }
            },
            padding: const EdgeInsets.only(
              left: StaticData.sidePadding,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Мои линзы',
                            style: AppStyles.h1,
                          ),
                          if (myLensesWM.lensesPairModel.value != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    myLensesWM.currentProduct.value!.name,
                                    style: AppStyles.p1,
                                  ),
                                  Text(
                                    myLensesWM.currentProduct.value!.lifeTime >
                                            1
                                        ? 'Плановой замены'
                                        : 'Однодневные',
                                    style: AppStyles.p1,
                                  ),
                                  if (myLensesWM
                                          .currentProduct.value!.lifeTime >
                                      1)
                                    Text(
                                      'До ${myLensesWM.currentProduct.value!.lifeTime} суток',
                                      style: AppStyles.p1,
                                    ),
                                ],
                              ),
                            )
                          else
                            const Text(
                              'История ношения, сроки замены и параметры линз всегда под рукой',
                              style: AppStyles.p1,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // TODO(pavlov): с этого момента фильтровать все ситуации
                    Expanded(
                      child: myLensesWM.lensesPairModel.value != null
                          ? leftLensDate != null && leftLensDate.daysLeft >= 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    CircularPercentIndicator(
                                      radius: 25,
                                      animation: true,
                                      animationDuration: 2000,
                                      lineWidth: 6.0,
                                      percent: leftLensDate.daysLeft >=
                                              myLensesWM.currentProduct.value!
                                                  .lifeTime
                                          ? 1
                                          : leftLensDate.daysLeft /
                                              myLensesWM.currentProduct.value!
                                                  .lifeTime,
                                      center: Text(
                                        leftLensDate.daysLeft.toString(),
                                        style: AppStyles.h1,
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      backgroundColor: AppTheme.mystic,
                                      progressColor: AppTheme.sulu,
                                    ),
                                    Text(
                                      HelpFunctions.formatDateRu(
                                        date: leftLensDate.dateStart,
                                      ),
                                      style: AppStyles.n1,
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3),
                                        child: Container(
                                          height: 48,
                                          width: 48,
                                          decoration: BoxDecoration(
                                            color: leftLensDate!.daysLeft == -1
                                                ? AppTheme.sulu
                                                : const Color(0xffff7878),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            'assets/icons/loading.png',
                                            scale: 3,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 4),
                                        alignment: Alignment.topRight,
                                        child: const Text(
                                          'Замените\nлинзы',
                                          style: AppStyles.n1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                          : Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Image.asset(
                                'assets/my_lenses.png',
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                    ),
                  ],
                ),
                if (myLensesWM.lensesPairModel.value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: GreyButton(
                      text: leftLensDate != null || rightLensDate != null
                          ? 'Завершить ношение'
                          : 'Надеть',
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: StaticData.sidePadding,
                      ),
                      onPressed: () async {
                        if (leftLensDate != null || rightLensDate != null) {
                          await myLensesWM.putOffLenses(context: context);
                        } else {
                          await showModalBottomSheet<num>(
                            isScrollControlled: true,
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.8),
                            builder: (context) {
                              return PutOnDateSheet(
                                onConfirmed: ({
                                  leftDate,
                                  rightDate,
                                }) =>
                                    myLensesWM.putOnLenses(
                                  leftDate: leftDate,
                                  rightDate: rightDate,
                                ),
                                leftPut: DateTime.now(),
                                rightPut: DateTime.now(),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
