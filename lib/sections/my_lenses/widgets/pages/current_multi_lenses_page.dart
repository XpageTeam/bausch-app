import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/models/my_lenses/lenses_worn_history_list_model.dart';
import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/home/widgets/simple_slider/simple_slider.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/chosen_lenses.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_description.dart';
import 'package:bausch/sections/my_lenses/widgets/lenses_history.dart';
import 'package:bausch/sections/my_lenses/widgets/one_lens_replacement_indicator.dart';
import 'package:bausch/sections/my_lenses/widgets/recommended_product.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/reminder_sheet.dart';
import 'package:bausch/sections/my_lenses/widgets/two_lens_replacement_indicator.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CurrentMultiLensesPage extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const CurrentMultiLensesPage({required this.myLensesWM, Key? key})
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
                    // сравниваем по дате окончания
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
          child: StreamedStateBuilder<bool>(
            streamedState: myLensesWM.remindersLoading,
            builder: (_, remindersLoading) => remindersLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: AnimatedLoader()),
                  )
                : WhiteContainerWithRoundedCorners(
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
                                  streamedState: myLensesWM.remindersShowWidget,
                                  builder: (_, object) => Text(
                                    object[0] != ''
                                        ? object[0]
                                        : '${object[1]} ${int.parse(object[1]) > 4 ? 'дат' : 'даты'}',
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
                            currentReminders: myLensesWM.multiRemindes.value,
                            onSendUpdate: (notifications) async =>
                                myLensesWM.updateMultiReminders(
                              // TODO(info): везде листы так передавать
                              reminders: [...notifications],

                              context: context,
                            ),
                          );
                        },
                      );
                    },
                  ),
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
        StreamedStateBuilder<List<LensesWornHistoryModel>>(
          streamedState: myLensesWM.wornHistoryList,
          builder: (_, wornHistoryList) => LensesHistory(
            wornHistoryList: wornHistoryList,
            expandList: () async =>
                myLensesWM.loadWornHistory(showAll: true, isOld: false),
          ),
        ),
      ],
    );
  }
}
