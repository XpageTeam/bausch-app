import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/chosen_lenses.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_description.dart';
import 'package:bausch/sections/my_lenses/widgets/one_lens_replacement_indicator.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/reminder_sheet.dart';
import 'package:bausch/sections/my_lenses/widgets/two_lens_replacement_indicator.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CurrentLensesPage extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const CurrentLensesPage({required this.myLensesWM, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamedStateBuilder<bool>(
          streamedState: myLensesWM.bothPuttedOn,
          builder: (_, puttedOn) => StreamedStateBuilder<bool>(
            streamedState: myLensesWM.lensesDifferentLife,
            builder: (_, lensesDifferentLife) => puttedOn
                ? lensesDifferentLife
                    ? TwoLensReplacementIndicator(myLensesWM: myLensesWM)
                    : OneLensReplacementIndicator(myLensesWM: myLensesWM)
                : const SizedBox.shrink(),
          ),
        ),
        ChosenLenses(myLensesWM: myLensesWM),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: WhiteContainerWithRoundedCorners(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: StaticData.sidePadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Напомнить о замене',
                  style: AppStyles.h2,
                ),
                Row(
                  children: [
                    StreamedStateBuilder<List<String>>(
                      streamedState: myLensesWM.notificationStatus,
                      builder: (_, object) => Text(
                        object[0] != ''
                            ? object[0]
                            : '${object[1]} напомина...',
                        style: AppStyles.h2,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_sharp,
                      size: 20,
                      color: AppTheme.mineShaft,
                    ),
                  ],
                ),
              ],
            ),
            onTap: () async {
              await showModalBottomSheet<num>(
                isScrollControlled: true,
                context: context,
                barrierColor: Colors.black.withOpacity(0.8),
                builder: (context) {
                  return ReminderSheet(
                    valuesMap: myLensesWM.notificationsList,
                    customValue: myLensesWM.customNotification,
                    onSendUpdate: myLensesWM.updateNotifications,
                  );
                },
              );
            },
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
        const Text(
          'История ношения',
          style: AppStyles.h1,
        ),
        const SizedBox(height: 20),
        if (myLensesWM.historyList.isNotEmpty)
          WhiteContainerWithRoundedCorners(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: StaticData.sidePadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        'Надеты',
                        style: AppStyles.p1Grey,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Заменены',
                        style: AppStyles.p1Grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: myLensesWM.historyList.length,
                  itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Text(
                          myLensesWM.historyList[index],
                          style: AppStyles.p1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          child: Image.asset(
                            'assets/line_dots.png',
                            scale: 4.1,
                          ),
                        ),
                        Text(
                          myLensesWM.historyList[index],
                          style: AppStyles.p1,
                        ),
                      ],
                    ),
                  ),
                ),
                const GreyButton(
                  text: 'Ранее',
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: StaticData.sidePadding,
                  ),
                ),
              ],
            ),
          )
        else
          const WhiteContainerWithRoundedCorners(
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: StaticData.sidePadding,
            ),
            child: Text(
              'Здесь мы покажем когда вы надели линзы и когда сняли. Это удобно ',
              style: AppStyles.p1Grey,
            ),
          ),
      ],
    );
  }
}
