import 'package:bausch/help/help_functions.dart';
import 'package:bausch/packages/bottom_sheet/src/widgets/flexible_draggable_scrollable_sheet.dart';
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
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';

class DailyNotificationsSheet extends StatefulWidget {
  final MyLensesWM myLensesWM;
  final FlexibleDraggableScrollableSheetScrollController controller;
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
  bool isUpdating = false;

  @override
  void initState() {
    currentReplay = widget.myLensesWM.dailyReminders.value!.replay;
    currentReminderDate =
        DateTime.parse(widget.myLensesWM.dailyReminders.value!.date);
    currentNotificationStatus = [...widget.myLensesWM.notificationStatus.value];
    currentReminders = widget.myLensesWM.dailyReminders.value!.reminders;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      bottomNavBar: showDatePicker || isUpdating
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
                vertical: 26,
              ),
              child: BlueButtonWithText(
                text: 'Сохранить',
                onPressed: () async {
                  setState(() {
                    isUpdating = true;
                  });
                  await widget.myLensesWM.updateRemindersBuy(
                    defaultValue: false,
                    context: context,
                    replay: currentReplay,
                    date: currentReminderDate.toIso8601String(),
                    reminders: currentReminders,
                    isSubscribed: true,
                  );
                  // TODO(check): успевает ли срабатывать
                  await widget.myLensesWM.notificationStatus
                      .accept(currentNotificationStatus);
                },
              ),
            ),
      controller: widget.controller,
      slivers: [
        if (isUpdating)
          const SliverPadding(
            padding: EdgeInsets.only(top: 100),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: AnimatedLoader(),
              ),
            ),
          )
        else
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
                            color:
                                showDatePicker ? AppTheme.turquoiseBlue : null,
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
                          if (reminders.length == 1) {
                            switch (reminders[0]) {
                              case '0':
                                currentNotificationStatus = [
                                  'В день покупки',
                                  '0',
                                ];
                                break;
                              case '1':
                                currentNotificationStatus = [
                                  'За 1 день',
                                  '1',
                                ];
                                break;
                              case '2':
                                currentNotificationStatus = [
                                  'За 2 дня',
                                  '2',
                                ];
                                break;
                              case '3':
                                currentNotificationStatus = [
                                  'За 3 дня',
                                  '3',
                                ];
                                break;
                              case '4':
                                currentNotificationStatus = [
                                  'За 4 дня',
                                  '4',
                                ];
                                break;
                              case '5':
                                currentNotificationStatus = [
                                  'За 5 дней',
                                  '5',
                                ];
                                break;
                              case '7':
                                currentNotificationStatus = [
                                  'За неделю',
                                  '7',
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
                                ? currentNotificationStatus[0] ==
                                        'В день замены'
                                    ? 'В день покупки'
                                    : currentNotificationStatus[0]
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
