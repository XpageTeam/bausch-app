import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_indicator_status.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_date_sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class OneLensReplacementIndicator extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const OneLensReplacementIndicator({required this.myLensesWM, Key? key})
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
          builder: (_, replacementDay) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 30,
                ),
                child: LensIndicatorStatus(
                  replacementDay: replacementDay,
                  onTap: () async =>
                      myLensesWM.rightReplacementDay.accept('Нет'),
                ),
              ),
              Row(
                children: [
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
                      replacementDay == 'Просрочен'
                          ? 'assets/short_line_dots.png'
                          : 'assets/line_dots.png',
                      scale: 3,
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
                  if (replacementDay == 'Просрочен')
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        '+ 800',
                        style: AppStyles.p1.copyWith(color: Colors.red),
                      ),
                    ),
                ],
              ),
              Padding(
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
                          onConfirmed: ({leftDate, rightDate}) {
                            myLensesWM.putOnLenses(
                              leftDate: leftDate,
                              rightDate: rightDate,
                              differentLife: true,
                            );
                          },
                          lenseLost: true,
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Row(
                  children: [
                    if (replacementDay == 'Нет')
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
                        text: replacementDay == 'Нет'
                            ? 'Завершить'
                            : 'Завершить ношение',
                        onPressed: () async =>
                            myLensesWM.bothPuttedOn.accept(false),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
