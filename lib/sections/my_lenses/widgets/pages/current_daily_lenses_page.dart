import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/models/my_lenses/reminders_buy_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/home/widgets/simple_slider/simple_slider.dart';
import 'package:bausch/sections/my_lenses/choose_lenses/choose_lenses_screen.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_description.dart';
import 'package:bausch/sections/my_lenses/widgets/recommended_product.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/activate_lenses_sheet.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/daily_notifications_sheet.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:extended_image/extended_image.dart';
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          myLensesWM.currentProduct.value!.name,
                          style: AppStyles.h2,
                        ),
                        const Text('Однодневные', style: AppStyles.p1),
                        Text(
                          HelpFunctions.pairs(
                            int.parse(
                              myLensesWM.currentProduct.value!.count,
                            ),
                          ),
                          style: AppStyles.p1,
                        ),
                      ],
                    ),
                  ),
                  ExtendedImage.network(
                    myLensesWM.currentProduct.value!.image,
                    height: 100,
                    width: 100,
                    loadStateChanged: onLoadStateChanged,
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
                      onPressed: () => Keys.mainContentNav.currentState!
                          .pushNamed(
                        '/choose_lenses',
                        arguments: ChooseLensesScreenArguments(
                          isEditing: true,
                          lensesPairModel: myLensesWM.lensesPairModel.value,
                        ),
                      )
                          .then((value) {
                        myLensesWM.loadAllData();
                      }),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        StreamedStateBuilder<bool>(
          streamedState: myLensesWM.remindersLoading,
          builder: (_, remindersLoading) => remindersLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: AnimatedLoader()),
                )
              : StreamedStateBuilder<RemindersBuyModel?>(
                  streamedState: myLensesWM.dailyReminders,
                  builder: (_, dailyReminders) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WhiteContainerWithRoundedCorners(
                          padding: const EdgeInsets.only(
                            top: 16,
                            bottom: 16,
                            left: StaticData.sidePadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Напомнить о покупке\nновой упаковки',
                                      style: AppStyles.h2,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await myLensesWM.updateDailyReminders(
                                        defaultValue: true,
                                        date: null,
                                        reminders: null,
                                        replay: null,
                                        subscribe: dailyReminders == null,
                                      );
                                      if (dailyReminders == null) {
                                        await myLensesWM
                                            .activateUserPushNotifications(
                                          context: context,
                                        );
                                      }
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.all(
                                        StaticData.sidePadding,
                                      ),
                                      child: CustomCheckbox(
                                        marginNeeded: false,
                                        value: dailyReminders != null,
                                        onChanged: (isSubscribe) async {
                                          await myLensesWM.updateDailyReminders(
                                            defaultValue: true,
                                            date: null,
                                            reminders: null,
                                            replay: null,
                                            subscribe: isSubscribe!,
                                          );
                                          if (isSubscribe) {
                                            await myLensesWM
                                                .activateUserPushNotifications(
                                              context: context,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (dailyReminders != null) ...[
                                Text(
                                  '${dailyReminders.replay == '' ? 'Никогда' : dailyReminders.replay == '5' ? 'Каждые 5 недель' : 'Каждые ${dailyReminders.replay} недели'}\nБлижайшая ${DateTime.parse(dailyReminders.date).day} ${HelpFunctions.getMonthNameByNumber(DateTime.parse(dailyReminders.date).month, fullLength: true)} ${DateTime.parse(dailyReminders.date).year}',
                                  style: AppStyles.p1Grey,
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GreyButton(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        text: 'Настроить',
                                        onPressed: () async {
                                          await showFlexibleBottomSheet<void>(
                                            minHeight: 0,
                                            initHeight: 0.95,
                                            maxHeight: 0.95,
                                            anchors: [0, 0.6, 0.95],
                                            context: context,
                                            bottomSheetColor:
                                                Colors.transparent,
                                            barrierColor:
                                                Colors.black.withOpacity(0.8),
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
                                    const SizedBox(
                                      width: StaticData.sidePadding,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (dailyReminders != null)
                          const SizedBox.shrink()
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Warning.warning(
                              'Поставьте напоминание, чтобы не забыть купить новую упаковку',
                            ),
                          ),
                      ],
                    ),
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
