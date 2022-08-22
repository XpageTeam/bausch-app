import 'package:bausch/packages/bottom_sheet/bottom_sheet.dart';
import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_description.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/daily_notifications_sheet.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CurrentDailyLensesPage extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const CurrentDailyLensesPage({required this.myLensesWM, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WhiteContainerWithRoundedCorners(
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
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Row(children: [
                  Expanded(
                    child: GreyButton(
                      text: 'Изменить',
                      onPressed: () =>
                          Keys.mainContentNav.currentState!.pushNamed(
                        '/choose_lenses',
                        arguments: [true],
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        StreamedStateBuilder<bool>(
          streamedState: myLensesWM.dailyReminder,
          builder: (_, dailyReminder) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: WhiteContainerWithRoundedCorners(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: StaticData.sidePadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Напомнить о покупке\nновой упаковки',
                        style: AppStyles.h2,
                      ),
                      CustomCheckbox(
                        marginNeeded: false,
                        value: myLensesWM.dailyReminder.value,
                        onChanged: (value) {
                          myLensesWM.dailyReminder.accept(value!);
                        },
                      ),
                    ],
                  ),
                  if (dailyReminder) ...[
                    StreamedStateBuilder<String>(
                      streamedState: myLensesWM.dailyReminderRepeat,
                      builder: (_, dailyReminderRepeat) => Text(
                        '$dailyReminderRepeat\nближайшая 27 сентября 2022',
                        style: AppStyles.p1Grey,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: GreyButton(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            text: 'Настроить',
                            onPressed: () async {
                              await showFlexibleBottomSheet<void>(
                                useRootNavigator: false,
                                minHeight: 0,
                                initHeight: 0.95,
                                maxHeight: 0.95,
                                anchors: [0, 0.6, 0.95],
                                context: context,
                                isCollapsible: true,
                                builder: (context, controller, d) {
                                  return SheetWidget(
                                    child: DailyNotificationsSheet(
                                      myLensesWM: myLensesWM,
                                    ),
                                    withPoints: false,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        StreamedStateBuilder<bool>(
          streamedState: myLensesWM.dailyReminder,
          builder: (_, dailyReminder) => dailyReminder
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Warning.warning(
                    'Поставьте напоминание, чтобы не забыть купить новую упаковку',
                  ),
                ),
        ),
        WhiteContainerWithRoundedCorners(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: StaticData.sidePadding,
          ),
          child: Row(
            children: const [
              Expanded(child: LensDescription(title: 'L')),
              Expanded(child: LensDescription(title: 'R')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: MayBeInteresting(text: 'Рекомендуемые продукты'),
        ),
      ],
    );
  }
}
