import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
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
        // TODO(pavlov): при одинаковой жизни для двух линз показываем 1 кружок
        StreamedStateBuilder<LensDateModel?>(
          streamedState: myLensesWM.leftLensDate,
          builder: (_, leftLensDate) => StreamedStateBuilder<LensDateModel?>(
            streamedState: myLensesWM.rightLensDate,
            builder: (_, rightLensDate) =>
                leftLensDate != null && rightLensDate != null
                    ? TwoLensReplacementIndicator(myLensesWM: myLensesWM)
                    : leftLensDate != null || rightLensDate != null
                        ? OneLensReplacementIndicator(
                            myLensesWM: myLensesWM,
                            isLeft: leftLensDate != null,
                            activeLensModel: leftLensDate ?? rightLensDate!,
                          )
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
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Напомнить о замене',
                    style: AppStyles.h2,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 3,
                        child: StreamedStateBuilder<List<String>>(
                          streamedState: myLensesWM.notificationStatus,
                          builder: (_, object) => Text(
                            object[0] != ''
                                ? object[0]
                                : '${object[1]} напомина...',
                            style: AppStyles.h2,
                            softWrap: false,
                            // TODO(info): сделал затемнение, потому что с точками проблема
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Icon(
                          Icons.chevron_right_sharp,
                          size: 20,
                          color: AppTheme.mineShaft,
                        ),
                      ),
                    ],
                  ),
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
                    notifications: myLensesWM.notificationsList,
                    onSendUpdate: (notifications) =>
                        myLensesWM.updateNotifications(
                      notifications: notifications,
                    ),
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
            children: [
              Expanded(
                child: LensDescription(
                  title: 'L',
                  pairModel: myLensesWM.lensesPairModel.value!.left,
                ),
              ),
              Expanded(
                child: LensDescription(
                  title: 'R',
                  pairModel: myLensesWM.lensesPairModel.value!.right,
                ),
              ),
            ],
          ),
        ),

        // TODO(ask): разобраться нужно тут что-то еще получать или нет
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
