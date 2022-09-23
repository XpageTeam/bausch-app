import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/my_lenses/lenses_worn_history_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/home/widgets/simple_slider/simple_slider.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/chosen_lenses.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_description.dart';
import 'package:bausch/sections/my_lenses/widgets/one_lens_replacement_indicator.dart';
import 'package:bausch/sections/my_lenses/widgets/recommended_product.dart';
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
        StreamedStateBuilder<LensDateModel?>(
          streamedState: myLensesWM.leftLensDate,
          builder: (_, leftLensDate) => StreamedStateBuilder<LensDateModel?>(
            streamedState: myLensesWM.rightLensDate,
            builder: (_, rightLensDate) =>
                leftLensDate != null && rightLensDate != null
                    // TODO(info): сравниваем по дате окончания
                    ? leftLensDate.dateEnd != rightLensDate.dateEnd
                        ? TwoLensReplacementIndicator(myLensesWM: myLensesWM)
                        : OneLensReplacementIndicator(
                            myLensesWM: myLensesWM,
                            sameTime: true,
                            activeLensDate: leftLensDate,
                          )
                    : leftLensDate != null || rightLensDate != null
                        ? OneLensReplacementIndicator(
                            myLensesWM: myLensesWM,
                            isLeft: leftLensDate != null,
                            activeLensDate: leftLensDate ?? rightLensDate!,
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
                          // TODO(all): здесь нужно просклонять *даты*
                          builder: (_, object) => Text(
                            object[0] != '' ? object[0] : '${object[1]} даты',
                            style: AppStyles.h2,
                            softWrap: false,
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
                    onSendUpdate: (notifications) async =>
                        myLensesWM.updateNotifications(
                      // TODO(info): везде листы так передавать
                      notifications: [...notifications],
                      shouldPop: true,
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
        // TODO(pavlov): везде в линзах применить, ждать его починки
        StreamedStateBuilder<List<RecommendedProductModel>>(
          streamedState: myLensesWM.recommendedProducts,
          builder: (_, dailyReminder) =>
              myLensesWM.recommendedProducts.value.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 30,
                            bottom: 16,
                          ),
                          child: Text(
                            'Рекомендуемые продукты',
                            style: AppStyles.h1,
                          ),
                        ),
                        SimpleSlider<RecommendedProductModel>(
                          items: myLensesWM.recommendedProducts.value,
                          builder: (context, product) {
                            return RecommendedProduct(product: product);
                          },
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
        ),
        const SizedBox(height: 20),
        // TODO(pavlov): перекрасить тут активые линзы
        Row(
          children: [
            Expanded(
              child: StreamedStateBuilder<List<LensesWornHistoryModel>>(
                streamedState: myLensesWM.wornHistoryList,
                builder: (_, historyList) => historyList.isNotEmpty
                    ? WhiteContainerWithRoundedCorners(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
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
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Заменены',
                                    style: AppStyles.p1Grey,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: historyList.length,
                              itemBuilder: (_, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: [
                                    if (historyList[index].eye == 'LR')
                                      Image.asset(
                                        'assets/icons/halfed_circle.png',
                                        height: 16,
                                        width: 16,
                                      )
                                    else
                                      Container(
                                        height: 16,
                                        width: 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: historyList[index].eye == 'L'
                                              ? AppTheme.turquoiseBlue
                                              : AppTheme.sulu,
                                        ),
                                        child: Center(
                                          child: Text(
                                            historyList[index].eye,
                                            style: AppStyles.n1,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 8),
                                    Center(
                                      child: Text(
                                        HelpFunctions.formatDateRu(
                                          date: historyList[index].dateStart,
                                        ),
                                        style: AppStyles.p1,
                                      ),
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
                                    Center(
                                      child: historyList[index].dateEnd != null
                                          ? Text(
                                              HelpFunctions.formatDateRu(
                                                date:
                                                    historyList[index].dateEnd!,
                                              ),
                                              style: AppStyles.p1,
                                            )
                                          : const SizedBox.shrink(),
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
                    : const WhiteContainerWithRoundedCorners(
                        padding: EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: StaticData.sidePadding,
                        ),
                        child: Text(
                          'Покажем когда вы надели и сняли линзы',
                          style: AppStyles.p1Grey,
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
