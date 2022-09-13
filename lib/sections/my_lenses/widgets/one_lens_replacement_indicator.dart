import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_indicator_status.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_date_sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';

class OneLensReplacementIndicator extends StatelessWidget {
  final MyLensesWM myLensesWM;
  final LensDateModel activeLensModel;
  final bool isLeft;
  const OneLensReplacementIndicator({
    required this.myLensesWM,
    required this.activeLensModel,
    required this.isLeft,
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
                left: isLeft,
                lifeTime: myLensesWM.currentProduct.value!.lifeTime,
                daysBeforeReplacement: activeLensModel.daysLeft,
                onTap: () async => isLeft
                    ? myLensesWM.leftLensDate.accept(activeLensModel.copyWith(
                        daysLeft: myLensesWM.currentProduct.value!.lifeTime,
                      ))
                    : myLensesWM.rightLensDate.accept(activeLensModel.copyWith(
                        daysLeft: myLensesWM.currentProduct.value!.lifeTime,
                      )),
              ),
            ),
            Row(
              children: [
                Text(
                  HelpFunctions.formatDateRu(
                    date: activeLensModel.dateStart,
                  ),
                  style: AppStyles.p1,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 6,
                    right: 2,
                  ),
                  child: Image.asset(
                    activeLensModel.daysLeft < 0
                        ? 'assets/short_line_dots.png'
                        : 'assets/line_dots.png',
                    scale: 3,
                  ),
                ),
                const Icon(
                  Icons.notifications_none,
                  size: 18,
                ),
                Text(
                  HelpFunctions.formatDateRu(
                    date: activeLensModel.dateEnd,
                  ),
                  style: AppStyles.p1,
                ),
                if (activeLensModel.daysLeft < 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      activeLensModel.daysLeft.toString(),
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
                  if (activeLensModel.daysLeft > 0)
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
                              return PutOnDateSheet(
                                leftPut:
                                    myLensesWM.leftLensDate.value!.dateStart,
                                rightPut:
                                    myLensesWM.rightLensDate.value!.dateStart,
                                onConfirmed: ({leftDate, rightDate}) {
                                  myLensesWM.putOnLenses(
                                    leftDate: leftDate,
                                    rightDate: rightDate,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: BlueButtonWithText(
                      text: activeLensModel.daysLeft > 0
                          ? 'Завершить'
                          : 'Завершить ношение',
                      onPressed: () async => isLeft
                          ? myLensesWM.leftLensDate.accept(null)
                          : myLensesWM.rightLensDate.accept(null),
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
