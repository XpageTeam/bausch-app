import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_date_sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ChosenLenses extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const ChosenLenses({required this.myLensesWM, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteContainerWithRoundedCorners(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: StaticData.sidePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Продукт',
                      style: AppStyles.h2,
                    ),
                    Text(
                      'срок действия',
                      style: AppStyles.p1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 100,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          StreamedStateBuilder<bool>(
            streamedState: myLensesWM.leftPuttedOn,
            builder: (_, leftPuttedOn) => StreamedStateBuilder<bool>(
              streamedState: myLensesWM.rightPuttedOn,
              builder: (_, rightPuttedOn) => leftPuttedOn == true &&
                      rightPuttedOn == true
                  ? const SizedBox.shrink()
                  : leftPuttedOn
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GreyButton(
                                  text: 'Надеть правую линзу',
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  onPressed: () async =>
                                      showModalBottomSheet<num>(
                                    isScrollControlled: true,
                                    context: context,
                                    barrierColor: Colors.black.withOpacity(0.8),
                                    builder: (context) {
                                      return PutOnDateSheet(
                                        onConfirmed: () {
                                          myLensesWM.rightPuttedOn.accept(true);
                                        },
                                        rightLens: true,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : rightPuttedOn
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GreyButton(
                                      text: 'Надеть левую линзу',
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      onPressed: () async =>
                                          showModalBottomSheet<num>(
                                        isScrollControlled: true,
                                        context: context,
                                        barrierColor:
                                            Colors.black.withOpacity(0.8),
                                        builder: (context) {
                                          return PutOnDateSheet(
                                            onConfirmed: () {
                                              myLensesWM.leftPuttedOn
                                                  .accept(true);
                                            },
                                            leftLens: true,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    // TODO(ask): как будет выглядеть экран изменить?
                                    child: GreyButton(
                                      text: 'Изменить',
                                      onPressed: () => Keys
                                          .mainContentNav.currentState!
                                          .pushNamed(
                                        '/choose_lenses',
                                        arguments: [true],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: BlueButtonWithText(
                                      text: 'Надеть',
                                      onPressed: () async =>
                                          showModalBottomSheet<num>(
                                        isScrollControlled: true,
                                        context: context,
                                        barrierColor:
                                            Colors.black.withOpacity(0.8),
                                        builder: (context) {
                                          return PutOnDateSheet(
                                            onConfirmed: () {
                                              myLensesWM.bothPuttedOn
                                                  .accept(true);
                                              myLensesWM.leftPuttedOn
                                                  .accept(true);
                                              myLensesWM.rightPuttedOn
                                                  .accept(true);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
