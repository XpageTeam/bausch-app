import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_indicator_status.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/different_lenses_sheet.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_date_sheet.dart';
import 'package:bausch/sections/my_lenses/widgets/start_end_date_line.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';

class OneLensReplacementIndicator extends StatelessWidget {
  final MyLensesWM myLensesWM;
  final LensDateModel activeLensDate;
  final bool isLeft;
  final bool sameTime;
  const OneLensReplacementIndicator({
    required this.myLensesWM,
    required this.activeLensDate,
    this.isLeft = false,
    this.sameTime = false,
    Key? key,
  }) : super(key: key);

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
            Padding(
              padding: const EdgeInsets.only(
                bottom: 30,
              ),
              child: LensIndicatorStatus(
                sameTime: sameTime,
                isAloneChildCircle: true,
                isLeft: isLeft,
                lifeTime: myLensesWM.currentProduct.value!.lifeTime,
                daysBeforeReplacement: activeLensDate.daysLeft,
                onTap: () async {
                  await myLensesWM.updateLensesDates(
                    leftDate: DateTime.now(),
                    rightDate: DateTime.now(),
                  );
                },
              ),
            ),
            StartEndDateLine(
              myLensesWM: myLensesWM,
              isLeft: isLeft,
              hasIcon: !sameTime,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Row(
                children: [
                  if (activeLensDate.daysLeft > 0)
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
                              if (sameTime) {
                                return DifferentLensesSheet(
                                  onConfirmed: ({leftDate, rightDate}) {
                                    myLensesWM.updateLensesDates(
                                      leftDate: leftDate,
                                      rightDate: rightDate,
                                    );
                                  },
                                  leftDate:
                                      myLensesWM.leftLensDate.value!.dateStart,
                                  rightDate:
                                      myLensesWM.rightLensDate.value!.dateStart,
                                );
                              } else {
                                return PutOnDateSheet(
                                  leftPut:
                                      myLensesWM.leftLensDate.value?.dateStart,
                                  rightPut:
                                      myLensesWM.rightLensDate.value?.dateStart,
                                  onConfirmed: ({leftDate, rightDate}) {
                                    myLensesWM.updateLensesDates(
                                      leftDate: leftDate,
                                      rightDate: rightDate,
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: BlueButtonWithText(
                      text: activeLensDate.daysLeft > 0
                          ? 'Завершить'
                          : 'Завершить ношение',
                      onPressed: () async =>
                          myLensesWM.putOffLenses(context: context),
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
