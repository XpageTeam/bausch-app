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
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

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
  late final String oldDailyReminderRepeat;
  late final List<String> oldNotificationStatus;
  late final DateTime? oldDailyRepeatReminderDate;
  bool showDatePicker = false;

  @override
  void initState() {
    oldDailyReminderRepeat = widget.myLensesWM.dailyReminderRepeat.value;
    oldNotificationStatus = widget.myLensesWM.notificationStatus.value;
    oldDailyRepeatReminderDate =
        widget.myLensesWM.dailyReminderRepeatDate.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await widget.myLensesWM.dailyReminderRepeat
            .accept(oldDailyReminderRepeat);
        await widget.myLensesWM.notificationStatus
            .accept(oldNotificationStatus);
        await widget.myLensesWM.dailyReminderRepeatDate
            .accept(oldDailyRepeatReminderDate);
        return true;
      },
      child: CustomSheetScaffold(
        bottomNavBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
            vertical: 26,
          ),
          child: StreamedStateBuilder<DateTime?>(
            streamedState: widget.myLensesWM.dailyReminderRepeatDate,
            builder: (_, dailyReminderRepeatDate) => BlueButtonWithText(
              text: 'Сохранить',
              onPressed: dailyReminderRepeatDate != null
                  ? () {
                      Navigator.of(context).pop();
                    }
                  : null,
            ),
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
                      onTap: () {
                        widget.myLensesWM.dailyReminderRepeat
                            .accept(oldDailyReminderRepeat);
                        widget.myLensesWM.notificationStatus
                            .accept(oldNotificationStatus);
                        widget.myLensesWM.dailyReminderRepeatDate
                            .accept(oldDailyRepeatReminderDate);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Отменить',
                        style: AppStyles.h3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                StreamedStateBuilder<DateTime?>(
                  streamedState: widget.myLensesWM.dailyReminderRepeatDate,
                  builder: (_, dailyReminderRepeatDate) =>
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
                              color: showDatePicker
                                  ? AppTheme.turquoiseBlue
                                  : null,
                              text: dailyReminderRepeatDate == null
                                  ? 'Выбрать дату'
                                  : '${dailyReminderRepeatDate.day} ${dailyReminderRepeatDate.month} ${dailyReminderRepeatDate.year}',
                              onPressed: showDatePicker
                                  ? null
                                  : () => setState(() {
                                        if (dailyReminderRepeatDate == null) {
                                          widget.myLensesWM
                                              .dailyReminderRepeatDate
                                              .accept(DateTime.now());
                                        }
                                        showDatePicker = true;
                                      }),
                            ),
                          ],
                        ),
                        if (showDatePicker)
                          DatePickerWidget(
                            popWidget: false,
                            onMonthChangeStartWithFirstDate: false,
                            initialDateTime: DateTime.now(),
                            minDateTime: DateTime.now(),
                            locale: DateTimePickerLocale.ru,
                            onCancel: () {
                              setState(() {
                                showDatePicker = false;
                              });
                              widget.myLensesWM.dailyReminderRepeatDate
                                  .accept(null);
                            },
                            onChange: (date, i) => widget
                                .myLensesWM.dailyReminderRepeatDate
                                .accept(date),
                            dateFormat: 'dd.MM.yyyy',
                            onConfirm: (date, i) {
                              setState(() {
                                showDatePicker = false;
                              });
                              widget.myLensesWM.dailyReminderRepeatDate
                                  .accept(date);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                StreamedStateBuilder<String>(
                  streamedState: widget.myLensesWM.dailyReminderRepeat,
                  builder: (_, dailyReminderRepeat) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: WhiteContainerWithRoundedCorners(
                      onTap: () async => widget.myLensesWM.dailyReminderRepeat
                          .accept(await showModalBottomSheet<String?>(
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
                                      'Каждые 5 недели',
                                    ],
                                  );
                                },
                                barrierColor: Colors.black.withOpacity(0.8),
                              ) ??
                              dailyReminderRepeat),
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
                                dailyReminderRepeat,
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
                ),
                WhiteContainerWithRoundedCorners(
                  onTap: () async => showModalBottomSheet<String?>(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return ReminderSheet(
                        hasNoVariant: false,
                        notifications: widget.myLensesWM.notificationsList,
                        onSendUpdate: (notifications) =>
                            widget.myLensesWM.updateNotifications(
                          notifications: notifications,
                        ),
                      );
                    },
                    barrierColor: Colors.black.withOpacity(0.8),
                  ),
                  padding: const EdgeInsets.all(StaticData.sidePadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Уведомление',
                        style: AppStyles.h2,
                      ),
                      Row(
                        children: [
                          StreamedStateBuilder<List<String>>(
                            streamedState: widget.myLensesWM.notificationStatus,
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
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
