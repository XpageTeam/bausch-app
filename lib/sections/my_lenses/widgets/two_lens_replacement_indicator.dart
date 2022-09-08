import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_indicator_status.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/different_lenses_sheet.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_date_sheet.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_end_sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class TwoLensReplacementIndicator extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const TwoLensReplacementIndicator({required this.myLensesWM, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: WhiteContainerWithRoundedCorners(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: StaticData.sidePadding,
        ),
        child: StreamedStateBuilder<String>(
          streamedState: myLensesWM.rightReplacementDay,
          builder: (_, rightReplacementDay) => StreamedStateBuilder<String>(
            streamedState: myLensesWM.leftReplacementDay,
            builder: (_, leftReplacementDay) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Дней до замены',
                  style: AppStyles.h2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamedStateBuilder<DateTime?>(
                        streamedState: myLensesWM.leftPutDate,
                        builder: (_, leftPutDate) => leftPutDate != null
                            ? Expanded(
                                child: LensIndicatorStatus(
                                  replacementDay: leftReplacementDay,
                                  onTap: () async => myLensesWM
                                      .leftReplacementDay
                                      .accept('Нет'),
                                  title: false,
                                  left: true,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      StreamedStateBuilder<DateTime?>(
                        streamedState: myLensesWM.rightPutDate,
                        builder: (_, rightPutDate) => rightPutDate != null
                            ? Expanded(
                                child: LensIndicatorStatus(
                                  replacementDay: rightReplacementDay,
                                  onTap: () async => myLensesWM
                                      .rightReplacementDay
                                      .accept('Нет'),
                                  title: false,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                StreamedStateBuilder<DateTime?>(
                  streamedState: myLensesWM.rightPutDate,
                  builder: (_, rightPutDate) => rightPutDate != null
                      ? Row(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 17,
                                width: 17,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.sulu,
                                ),
                                child: const Center(
                                  child: Text('R', style: AppStyles.n1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '5 май, 16:00',
                              style: AppStyles.p1,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 6,
                                right: 2,
                              ),
                              child: Image.asset(
                                rightReplacementDay == 'Просрочен'
                                    ? 'assets/short_line_dots.png'
                                    : 'assets/line_dots.png',
                                scale: 3.5,
                              ),
                            ),
                            const Icon(
                              Icons.notifications_none,
                              size: 18,
                            ),
                            const Text(
                              'Вс, 22 сен, 16:00',
                              style: AppStyles.p1,
                            ),
                            if (rightReplacementDay == 'Просрочен')
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  '+ 800',
                                  style:
                                      AppStyles.p1.copyWith(color: Colors.red),
                                ),
                              ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 13),
                StreamedStateBuilder<DateTime?>(
                  streamedState: myLensesWM.leftPutDate,
                  builder: (_, leftPutDate) => leftPutDate != null
                      ? Row(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 17,
                                width: 17,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.turquoiseBlue,
                                ),
                                child: const Center(
                                  child: Text('L', style: AppStyles.n1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '5 май, 16:00',
                              style: AppStyles.p1,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 6,
                                right: 2,
                              ),
                              child: Image.asset(
                                rightReplacementDay == 'Просрочен'
                                    ? 'assets/short_line_dots.png'
                                    : 'assets/line_dots.png',
                                scale: 3.5,
                              ),
                            ),
                            const Icon(
                              Icons.notifications_none,
                              size: 18,
                            ),
                            const Text(
                              'Вс, 22 сен, 16:00',
                              style: AppStyles.p1,
                            ),
                            if (rightReplacementDay == 'Просрочен')
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  '+ 800',
                                  style:
                                      AppStyles.p1.copyWith(color: Colors.red),
                                ),
                              ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                StreamedStateBuilder<bool>(
                  streamedState: myLensesWM.lensesDifferentLife,
                  builder: (_, lensesDifferentLife) => !lensesDifferentLife
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 8),
                          child: GreyButton(
                            text: 'Потерялась одна линза',
                            leftIcon: Image.asset(
                              'assets/substract.png',
                              height: 16,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: StaticData.sidePadding,
                            ),
                            onPressed: () async {
                              await showModalBottomSheet<num>(
                                isScrollControlled: true,
                                context: context,
                                barrierColor: Colors.black.withOpacity(0.8),
                                builder: (context) {
                                  return PutOnDateSheet(
                                    onConfirmed: ({
                                      leftDate,
                                      rightDate,
                                    }) {
                                      if (leftDate != rightDate) {
                                        myLensesWM.lensesDifferentLife
                                            .accept(true);
                                      }
                                      myLensesWM.leftPutDate.accept(leftDate);
                                      myLensesWM.rightPutDate.accept(rightDate);
                                    },
                                    lenseLost: true,
                                  );
                                },
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Row(
                    children: [
                      if (rightReplacementDay == 'Нет' ||
                          leftReplacementDay == 'Нет')
                        Expanded(
                          child: GreyButton(
                            text: 'Редактировать',
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            onPressed: () async {
                              await showModalBottomSheet<num>(
                                isScrollControlled: true,
                                context: context,
                                barrierColor: Colors.black.withOpacity(0.8),
                                builder: (context) {
                                  return myLensesWM.rightPutDate.value ==
                                              null ||
                                          myLensesWM.leftPutDate.value == null
                                      ? PutOnDateSheet(
                                          onConfirmed: ({
                                            leftDate,
                                            rightDate,
                                          }) {
                                              myLensesWM.rightPutDate
                                                .accept(rightDate);
                                                   myLensesWM.leftPutDate
                                                .accept(leftDate);
                                          },
                                          leftPut: myLensesWM.leftPutDate.value,
                                          rightPut:
                                              myLensesWM.rightPutDate.value,
                                        )
                                      : DifferentLensesSheet(
                                          onConfirmed: ({
                                            leftDate,
                                            rightDate,
                                          }) {
                                            myLensesWM.rightPutDate
                                                .accept(rightDate);
                                                   myLensesWM.leftPutDate
                                                .accept(leftDate);
                                          },
                                          leftDate:
                                              myLensesWM.leftPutDate.value!,
                                          rightDate:
                                              myLensesWM.rightPutDate.value!,
                                        );
                                },
                              );
                            },
                          ),
                        ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: BlueButtonWithText(
                          text: 'Завершить',
                          onPressed: () async {
                            if (myLensesWM.rightPutDate.value == null ||
                                myLensesWM.leftPutDate.value == null) {
                              await myLensesWM.bothPuttedOn.accept(false);
                              await myLensesWM.leftPutDate.accept(null);
                              await myLensesWM.rightPutDate.accept(null);
                            } else {
                              await showModalBottomSheet<void>(
                                isScrollControlled: true,
                                context: context,
                                barrierColor: Colors.black.withOpacity(0.8),
                                builder: (context) {
                                  return PutOnEndSheet(
                                    onLeftConfirmed: () {
                                      myLensesWM.leftPutDate.accept(null);
                                      if (myLensesWM.rightPutDate.value ==
                                          null) {
                                        myLensesWM.bothPuttedOn.accept(false);
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    onRightConfirmed: () {
                                      myLensesWM.rightPutDate.accept(null);
                                      if (myLensesWM.leftPutDate.value ==
                                          null) {
                                        myLensesWM.bothPuttedOn.accept(false);
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    onBothConfirmed: () {
                                      myLensesWM.bothPuttedOn.accept(false);
                                      myLensesWM.leftPutDate.accept(null);
                                      myLensesWM.rightPutDate.accept(null);
                                      Navigator.of(context).pop();
                                    },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
