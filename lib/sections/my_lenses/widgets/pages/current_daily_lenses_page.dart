import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/models/my_lenses/reminders_buy_model.dart';
import 'package:bausch/packages/bottom_sheet/bottom_sheet.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/home/widgets/simple_slider/simple_slider.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_description.dart';
import 'package:bausch/sections/my_lenses/widgets/recommended_product.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/daily_notifications_sheet.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          myLensesWM.currentProduct.value!.name,
                          style: AppStyles.h2,
                        ),
                        const Text(
                          'Однодневные',
                          style: AppStyles.p1,
                        ),
                        Text(
                          'Пар: ${myLensesWM.currentProduct.value!.count}',
                          style: AppStyles.p1,
                        ),
                      ],
                    ),
                  ),
                  Image.network(
                    myLensesWM.currentProduct.value!.image,
                    height: 100,
                    width: 100,
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
                        arguments: [true, myLensesWM.lensesPairModel.value],
                      ).then((value) {
                        myLensesWM.loadAllData();
                      }),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        StreamedStateBuilder<RemindersBuyModel?>(
          streamedState: myLensesWM.dailyReminders,
          builder: (_, dailyReminders) => Padding(
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
                    children: [
                      const Text(
                        'Напомнить о покупке\nновой упаковки',
                        style: AppStyles.h2,
                      ),
                      CustomCheckbox(
                        marginNeeded: false,
                        value: dailyReminders != null,
                        onChanged: (isSubscribed) {
                          myLensesWM.updateRemindersBuy(
                            defaultValue: true,
                            date: null,
                            reminders: null,
                            replay: null,
                            isSubscribed: isSubscribed!,
                          );
                        },
                      ),
                    ],
                  ),
                  if (dailyReminders != null) ...[
                    // TODO(pavlov): настроить дату как на макете
                    Text(
                      '${dailyReminders.replay == '' ? 'Никогда' : dailyReminders.replay == '5' ? 'Каждые 5 недель' : 'Каждые ${dailyReminders.replay} недели'}\nБлижайшая ${DateTime.parse(dailyReminders.date).day} ${DateFormat.MMMM('ru').format(DateTime.parse(dailyReminders.date))} ${DateTime.parse(dailyReminders.date).year}',
                      style: AppStyles.p1Grey,
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
                                minHeight: 0,
                                initHeight: 0.95,
                                maxHeight: 0.95,
                                anchors: [0, 0.6, 0.95],
                                context: context,
                                builder: (context, controller, d) {
                                  return SheetWidget(
                                    child: DailyNotificationsSheet(
                                      myLensesWM: myLensesWM,
                                      controller: controller,
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
        StreamedStateBuilder<RemindersBuyModel?>(
          streamedState: myLensesWM.dailyReminders,
          builder: (_, dailyReminders) => dailyReminders != null
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
      ],
    );
  }
}
