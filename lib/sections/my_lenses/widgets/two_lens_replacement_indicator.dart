import 'package:bausch/help/help_functions.dart';
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
        child: Column(
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
                  Expanded(
                    child: LensIndicatorStatus(
                      left: true,
                      lifeTime: myLensesWM.currentProduct.value!.lifeTime,
                      daysBeforeReplacement:
                          myLensesWM.leftLensDate.value!.daysLeft,
                      title: false,
                      onTap: () async => myLensesWM.putOnLenses(
                        leftDate: DateTime.now(),
                        rightDate: null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LensIndicatorStatus(
                      lifeTime: myLensesWM.currentProduct.value!.lifeTime,
                      daysBeforeReplacement:
                          myLensesWM.rightLensDate.value!.daysLeft,
                      title: false,
                      onTap: () async => myLensesWM.putOnLenses(
                        leftDate: null,
                        rightDate: DateTime.now(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
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
                Text(
                  HelpFunctions.formatDateRu(
                    date: myLensesWM.rightLensDate.value!.dateStart,
                  ),
                  // myLensesWM.rightLensDate.value!.dateStart.toString(),
                  style: AppStyles.p1,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 6,
                    right: 2,
                  ),
                  child: Image.asset(
                    myLensesWM.rightLensDate.value!.daysLeft < 0
                        ? 'assets/short_line_dots.png'
                        : 'assets/line_dots.png',
                    scale: 4.8,
                  ),
                ),
                const Icon(
                  Icons.notifications_none,
                  size: 18,
                ),
                Text(
                  HelpFunctions.formatDateRu(
                    date: myLensesWM.rightLensDate.value!.dateEnd,
                    haveWeekDay: true,
                  ),
                  style: AppStyles.p1,
                ),
                if (myLensesWM.rightLensDate.value!.daysLeft < 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      myLensesWM.rightLensDate.value!.daysLeft.toString(),
                      style: AppStyles.p1.copyWith(color: Colors.red),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 13),
            Row(
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
                Text(
                  HelpFunctions.formatDateRu(
                    date: myLensesWM.leftLensDate.value!.dateStart,
                  ),
                  style: AppStyles.p1,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 6,
                    right: 2,
                  ),
                  child: Image.asset(
                    myLensesWM.leftLensDate.value!.daysLeft < 0
                        ? 'assets/short_line_dots.png'
                        : 'assets/line_dots.png',
                    scale: 4.8,
                  ),
                ),
                const Icon(
                  Icons.notifications_none,
                  size: 18,
                ),
                Text(
                  HelpFunctions.formatDateRu(
                    date: myLensesWM.leftLensDate.value!.dateEnd,
                    haveWeekDay: true,
                  ),
                  style: AppStyles.p1,
                ),
                if (myLensesWM.leftLensDate.value!.daysLeft < 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      myLensesWM.leftLensDate.value!.daysLeft.toString(),
                      style: AppStyles.p1.copyWith(color: Colors.red),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Row(
                children: [
                  if (myLensesWM.leftLensDate.value!.daysLeft > 0 ||
                      myLensesWM.rightLensDate.value!.daysLeft > 0)
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
                              return myLensesWM.rightLensDate.value == null ||
                                      myLensesWM.leftLensDate.value == null
                                  ? PutOnDateSheet(
                                      onConfirmed: ({
                                        leftDate,
                                        rightDate,
                                      }) {
                                        myLensesWM.putOnLenses(
                                          leftDate: leftDate,
                                          rightDate: rightDate,
                                        );
                                      },
                                      leftPut: myLensesWM
                                          .leftLensDate.value!.dateStart,
                                      rightPut: myLensesWM
                                          .rightLensDate.value!.dateStart,
                                    )
                                  : DifferentLensesSheet(
                                      onConfirmed: ({
                                        leftDate,
                                        rightDate,
                                      }) {
                                        myLensesWM.putOnLenses(
                                          leftDate: leftDate,
                                          rightDate: rightDate,
                                        );
                                      },
                                      leftDate: myLensesWM
                                          .leftLensDate.value!.dateStart,
                                      rightDate: myLensesWM
                                          .rightLensDate.value!.dateStart,
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
                        if (myLensesWM.rightLensDate.value == null ||
                            myLensesWM.leftLensDate.value == null) {
                          await myLensesWM.leftLensDate.accept(null);
                          await myLensesWM.rightLensDate.accept(null);
                        } else {
                          await showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.8),
                            builder: (context) {
                              return PutOnEndSheet(
                                onLeftConfirmed: () {
                                  myLensesWM.leftLensDate.accept(null);
                                  Navigator.of(context).pop();
                                },
                                onRightConfirmed: () {
                                  myLensesWM.rightLensDate.accept(null);
                                  Navigator.of(context).pop();
                                },
                                onBothConfirmed: () {
                                  myLensesWM.leftLensDate.accept(null);
                                  myLensesWM.rightLensDate.accept(null);
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
    );
  }
}
