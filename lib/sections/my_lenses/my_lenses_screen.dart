import 'package:bausch/packages/flutter_cupertino_date_picker/flutter_cupertino_date_picker_fork.dart';
import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_description.dart';
import 'package:bausch/sections/my_lenses/widgets/lenses_page_switcher.dart';
import 'package:bausch/sections/my_lenses/widgets/reminder_bottom_sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class MyLensesScreen extends CoreMwwmWidget<MyLensesWM> {
  MyLensesScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => MyLensesWM(context: context),
        );

  @override
  WidgetState<CoreMwwmWidget<MyLensesWM>, MyLensesWM> createWidgetState() =>
      _MyLensesScreenState();
}

class _MyLensesScreenState extends WidgetState<MyLensesScreen, MyLensesWM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Мои линзы',
        backgroundColor: AppTheme.mystic,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
          vertical: 30,
        ),
        children: [
          // Переключатель (ношу сейчас/были раньше)
          LensesPageSwitcher(
            callback: wm.switchAction,
          ),
          const SizedBox(height: 22),
          StreamedStateBuilder<MyLensesPage>(
            streamedState: wm.currentPageStreamed,
            builder: (_, currentPage) => currentPage ==
                    MyLensesPage.currentLenses
                ? Column(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      onPressed: () async {
                                        DatePicker.showDatePicker(
                                          context,
                                          initialDateTime: DateTime.now(),
                                          minDateTime: DateTime(2021),
                                          maxDateTime: DateTime.now(),
                                          locale: DateTimePickerLocale.ru,
                                          onCancel: () {},
                                          dateFormat: 'dd.MM.yyyy',
                                          onConfirm: (date, i) {
                                            debugPrint('onchanged');
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                    streamedState: wm.notificationStatus,
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
                                return Wrap(children: [
                                  ReminderBottomSheet(
                                    valuesMap: wm.notificationsList,
                                    customValue: wm.customNotification,
                                    onSendUpdate: (valuesList, custom) =>
                                        wm.updateNotifications(
                                      valuesList,
                                      custom,
                                    ),
                                  ),
                                ]);
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
                      if (wm.historyList.isNotEmpty)
                        WhiteContainerWithRoundedCorners(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: StaticData.sidePadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                itemCount: wm.historyList.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (_, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        wm.historyList[index],
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
                                        wm.historyList[index],
                                        style: AppStyles.p1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const GreyButton(
                                text: 'Ранее',
                                paddingValue: 10,
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
                  )
                : Column(
                    children: const [Text('Старые линзы')],
                  ),
          ),
        ],
      ),
    );
  }
}
