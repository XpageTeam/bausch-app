import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_indicator_status.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/different_lenses_sheet.dart';
import 'package:bausch/sections/my_lenses/widgets/start_end_date_line.dart';
import 'package:bausch/static/static_data.dart';
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
                      isLeft: true,
                      lifeTime: myLensesWM.currentProduct.value!.lifeTime,
                      daysBeforeReplacement:  myLensesWM.leftLensDate.value!.daysLeft,
                      title: false,
                      onUpdateTap: () async => myLensesWM.putOnLensesPair(
                        leftDate: DateTime.now(),
                        rightDate: null,
                        updateLeft: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LensIndicatorStatus(
                      lifeTime: myLensesWM.currentProduct.value!.lifeTime,
                      daysBeforeReplacement:  myLensesWM.rightLensDate.value!.daysLeft,
                      title: false,
                      onUpdateTap: () async => myLensesWM.putOnLensesPair(
                        leftDate: null,
                        rightDate: DateTime.now(),
                        updateRight: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StartEndDateLine(myLensesWM: myLensesWM),
            const SizedBox(height: 13),
            StartEndDateLine(myLensesWM: myLensesWM, isLeft: false),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Row(
                children: [
                  if (myLensesWM.leftLensDate.value!.daysLeft >= 0 ||
                      myLensesWM.rightLensDate.value!.daysLeft >= 0)
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
                              return DifferentLensesSheet(
                                onConfirmed: ({leftDate, rightDate}) {
                                  myLensesWM.updateLensesPair(
                                    leftDate: leftDate,
                                    rightDate: rightDate,
                                  );
                                },
                                leftDate:
                                    myLensesWM.leftLensDate.value!.dateStart,
                                rightDate:
                                    myLensesWM.rightLensDate.value!.dateStart,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  if (myLensesWM.leftLensDate.value!.daysLeft > 0 ||
                      myLensesWM.rightLensDate.value!.daysLeft > 0)
                    const SizedBox(width: 3),
                  Expanded(
                    child: BlueButtonWithText(
                      text: 'Завершить',
                      onPressed: () async =>
                          myLensesWM.putOffLensesSheet(context: context),
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
