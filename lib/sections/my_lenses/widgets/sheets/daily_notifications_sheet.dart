import 'package:bausch/help/help_functions.dart';
import 'package:bausch/packages/flutter_cupertino_date_picker/flutter_cupertino_date_picker_fork.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/reminder_sheet.dart';
import 'package:bausch/sections/order_registration/widgets/single_picker_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';

class DailyNotificationsSheet extends StatefulWidget {
  final MyLensesWM myLensesWM;
  final ScrollController controller;
  const DailyNotificationsSheet({
    required this.myLensesWM,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<DailyNotificationsSheet> createState() =>
      _DailyNotificationsSheetState();
}

class _DailyNotificationsSheetState extends State<DailyNotificationsSheet> {
  List<String> currentNotificationStatus = [];
  String currentReplay = '';
  DateTime currentReminderDate = DateTime.now();
  List<String> currentReminders = [];
  bool showDatePicker = false;

  @override
  void initState() {
    currentReplay = widget.myLensesWM.dailyReminders.value!.replay;
    currentReminderDate =
        DateTime.parse(widget.myLensesWM.dailyReminders.value!.date);
    currentNotificationStatus = [
      ...widget.myLensesWM.remindersShowWidget.value,
    ];
    currentReminders = widget.myLensesWM.dailyReminders.value!.reminders;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      bottomNavBar: showDatePicker
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
                vertical: 26,
              ),
              child: BlueButtonWithText(
                text: 'Сохранить',
                onPressed: () async {
                  await widget.myLensesWM.updateDailyReminders(
                    defaultValue: false,
                    context: context,
                    replay: currentReplay,
                    date: currentReminderDate.toIso8601String(),
                    reminders: currentReminders,
                    subscribe: true,
                  );
                  await widget.myLensesWM.remindersShowWidget
                      .accept(currentNotificationStatus);
                },
              ),
            ),
      controller: widget.controller,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Напомнить о покупке\nновой упаковки',
                    style: AppStyles.h1,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Отменить',
                      style: AppStyles.h3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              WhiteContainerWithRoundedCorners(
                padding: const EdgeInsets.all(StaticData.sidePadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Дата напоминания',
                          style: AppStyles.h2,
                        ),
                        GreyButton(
                          padding: const EdgeInsets.only(
                            top: 4,
                            bottom: 8,
                            right: 8,
                            left: 8,
                          ),
                          color: showDatePicker ? AppTheme.turquoiseBlue : null,
                          text:
                              '${currentReminderDate.day} ${HelpFunctions.getMonthNameByNumber(currentReminderDate.month)} ${currentReminderDate.year}',
                          onPressed: showDatePicker
                              ? null
                              : () => setState(() {
                                    showDatePicker = true;
                                  }),
                        ),
                      ],
                    ),
                    if (showDatePicker)
                      DatePickerWidget(
                        popWidget: false,
                        onMonthChangeStartWithFirstDate: false,
                        initialDateTime: currentReminderDate,
                        minDateTime: DateTime.now(),
                        locale: DateTimePickerLocale.ru,
                        onCancel: () {
                          setState(() {
                            showDatePicker = false;
                            currentReminderDate = DateTime.parse(
                              widget.myLensesWM.dailyReminders.value!.date,
                            );
                          });
                        },
                        onChange: (date, i) => setState(() {
                          currentReminderDate = date;
                        }),
                        dateFormat: 'dd.MM.yyyy',
                        onConfirm: (date, i) {
                          setState(() {
                            showDatePicker = false;
                            currentReminderDate = date;
                          });
                        },
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: WhiteContainerWithRoundedCorners(
                  onTap: () async {
                    final pickedValue = await showModalBottomSheet<String?>(
                      context: context,
                      builder: (context) {
                        return SinglePickerScreen(
                          cancelTitle: 'Отменить',
                          onCancelTap: Navigator.of(context).pop,
                          acceptTitle: 'Готово',
                          title: 'Повтор',
                          variants: const [
                            'Никогда',
                            'Каждые 2 недели',
                            'Каждые 3 недели',
                            'Каждые 4 недели',
                            'Каждые 5 недель',
                          ],
                        );
                      },
                      barrierColor: Colors.black.withOpacity(0.8),
                    );
                    setState(() {
                      if (pickedValue != null && pickedValue == 'Никогда') {
                        currentReplay = '';
                      } else if (pickedValue != null) {
                        currentReplay = pickedValue[7];
                      }
                    });
                  },
                  padding: const EdgeInsets.all(StaticData.sidePadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Повтор',
                        style: AppStyles.h2,
                      ),
                      Row(
                        children: [
                          Text(
                            currentReplay == ''
                                ? 'Никогда'
                                : currentReplay == '5'
                                    ? 'Каждые 5 недель'
                                    : 'Каждые $currentReplay недели',
                            style: AppStyles.h2,
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
                ),
              ),
              WhiteContainerWithRoundedCorners(
                onTap: () async => showModalBottomSheet<String?>(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return ReminderSheet(
                      multiDayLife: false,
                      currentReminders: currentReminders,
                      onSendUpdate: (reminders) async => setState(() {
                        currentReminders = [...reminders];
                        if (reminders.isEmpty) {
                          currentNotificationStatus = [
                            'Нет',
                            '1',
                          ];
                        } else if (reminders.length == 1) {
                          switch (reminders[0]) {
                            case '0':
                              currentNotificationStatus = [
                                'В день покупки',
                                '1',
                              ];
                              break;
                            case '1':
                              currentNotificationStatus = [
                                'За неделю',
                                '1',
                              ];
                              break;
                          }
                        } else {
                          currentNotificationStatus = [
                            '',
                            reminders.length.toString(),
                          ];
                        }
                        Navigator.of(context).pop();
                      }),
                    );
                  },
                  barrierColor: Colors.black.withOpacity(0.8),
                ),
                padding: const EdgeInsets.all(StaticData.sidePadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Уведомление', style: AppStyles.h2),
                    Row(
                      children: [
                        Text(
                          currentNotificationStatus[0] != ''
                              ? currentNotificationStatus[0]
                              : '${currentNotificationStatus[1]} ${int.parse(currentNotificationStatus[1]) > 4 ? 'дат' : 'даты'}',
                          style: AppStyles.h2,
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
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
