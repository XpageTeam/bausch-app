import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/order_registration/widgets/single_picker_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

// TODO(pavlov): тут разобраться в отличии поведения однодневок
class ReminderSheet extends StatefulWidget {
  final List<MyLensesNotificationModel> notifications;
  final bool multiDayLife;
  final Future<void> Function(List<MyLensesNotificationModel>) onSendUpdate;
  const ReminderSheet({
    required this.notifications,
    required this.onSendUpdate,
    this.multiDayLife = true,
    Key? key,
  }) : super(key: key);

  @override
  State<ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends State<ReminderSheet> {
  final pickerNotifications = ['1 день', '2 дня', '3 дня', '4 дня', '5 дней'];
  String pickerNotification = '';
  List<MyLensesNotificationModel> currentNotifications = [];
  bool isUpdating = false;

  @override
  void initState() {
    currentNotifications = [...widget.notifications];
    if (currentNotifications[1].isActive) {
      pickerNotification = currentNotifications[1].title;
    }
    if (currentNotifications[2].isActive) {
      pickerNotification = currentNotifications[2].title;
    }
    if (currentNotifications[3].isActive) {
      pickerNotification = currentNotifications[3].title;
    }
    if (currentNotifications[5].isActive) {
      pickerNotification = currentNotifications[5].title;
    }
    if (currentNotifications[6].isActive) {
      pickerNotification = currentNotifications[6].title;
    }
    if (currentNotifications[7].isActive) {
      pickerNotification = currentNotifications[7].title;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isUpdating
        ? const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(
              child: AnimatedLoader(),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: ColoredBox(
              color: AppTheme.mystic,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  right: StaticData.sidePadding,
                  left: StaticData.sidePadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.mineShaft,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Напомнить о ${widget.multiDayLife ? 'замене' : 'покупке'}',
                          style: AppStyles.h1,
                        ),
                        GestureDetector(
                          onTap: () async {
                            for (var i = 0;
                                i < currentNotifications.length;
                                i++) {
                              currentNotifications[i] = currentNotifications[i]
                                  .copyWith(isActive: false);
                            }
                            currentNotifications[0] = currentNotifications[0]
                                .copyWith(isActive: true);
                            if (!isUpdating) {
                              setState(() {
                                isUpdating = true;
                              });
                              await widget.onSendUpdate(currentNotifications);
                              setState(() {
                                isUpdating = false;
                              });
                            }
                          },
                          child: const Text(
                            'Сбросить',
                            style: AppStyles.h3,
                          ),
                        ),
                      ],
                    ),
                    if (widget.multiDayLife)
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 4),
                        child: WhiteContainerWithRoundedCorners(
                          padding: const EdgeInsets.only(
                            left: StaticData.sidePadding,
                            top: 4,
                            bottom: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text(
                                  'Нет',
                                  style: AppStyles.h2,
                                ),
                              ),
                              CustomCheckbox(
                                value: currentNotifications[0].isActive,
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      for (var i = 0;
                                          i < currentNotifications.length;
                                          i++) {
                                        currentNotifications[i] =
                                            currentNotifications[i]
                                                .copyWith(isActive: false);
                                      }
                                      currentNotifications[0] =
                                          currentNotifications[0]
                                              .copyWith(isActive: true);
                                      pickerNotification = '';
                                    } else {
                                      currentNotifications[0] =
                                          currentNotifications[0]
                                              .copyWith(isActive: false);
                                    }
                                  });
                                },
                                borderRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (!widget.multiDayLife) const SizedBox(height: 30),
                    WhiteContainerWithRoundedCorners(
                      padding: const EdgeInsets.only(
                        left: StaticData.sidePadding,
                        top: 4,
                        bottom: 4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'В день ${widget.multiDayLife ? 'замены' : 'покупки'}',
                                  style: AppStyles.h2,
                                ),
                              ),
                              CustomCheckbox(
                                value: currentNotifications[1].isActive,
                                onChanged: (value) {
                                  setState(() {
                                    currentNotifications[1] =
                                        currentNotifications[1]
                                            .copyWith(isActive: value);
                                    if (value!) {
                                      currentNotifications[0] =
                                          currentNotifications[0]
                                              .copyWith(isActive: false);
                                    }
                                  });
                                },
                                borderRadius: 2,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Flexible(
                                  child: Text(
                                    'За 1 день',
                                    style: AppStyles.h2,
                                  ),
                                ),
                                CustomCheckbox(
                                  value: currentNotifications[2].isActive,
                                  onChanged: (value) {
                                    setState(() {
                                      currentNotifications[2] =
                                          currentNotifications[2]
                                              .copyWith(isActive: value);
                                      if (value!) {
                                        currentNotifications[0] =
                                            currentNotifications[0]
                                                .copyWith(isActive: false);
                                      }
                                    });
                                  },
                                  borderRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text(
                                  'За 2 дня',
                                  style: AppStyles.h2,
                                ),
                              ),
                              CustomCheckbox(
                                value: currentNotifications[3].isActive,
                                onChanged: (value) {
                                  setState(() {
                                    currentNotifications[3] =
                                        currentNotifications[3]
                                            .copyWith(isActive: value);
                                    if (value!) {
                                      currentNotifications[0] =
                                          currentNotifications[0]
                                              .copyWith(isActive: false);
                                    }
                                  });
                                },
                                borderRadius: 2,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text(
                                  'За неделю',
                                  style: AppStyles.h2,
                                ),
                              ),
                              CustomCheckbox(
                                value: currentNotifications[4].isActive,
                                onChanged: (value) {
                                  setState(() {
                                    currentNotifications[4] =
                                        currentNotifications[4]
                                            .copyWith(isActive: value);
                                    if (value!) {
                                      currentNotifications[0] =
                                          currentNotifications[0]
                                              .copyWith(isActive: false);
                                    }
                                  });
                                },
                                borderRadius: 2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: GestureDetector(
                        onTap: () async {
                          final pickerValue =
                              await showModalBottomSheet<String?>(
                                    context: context,
                                    builder: (context) {
                                      return SinglePickerScreen(
                                        title: 'Напомнить за',
                                        variants: pickerNotifications,
                                        cancelTitle: 'Отмена',
                                        onCancelTap: () {
                                          setState(() {
                                            pickerNotification = '';
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                    barrierColor: Colors.black.withOpacity(0.8),
                                  ) ??
                                  '';
                          setState(() {
                            if (pickerValue != '') {
                              pickerNotification = 'За $pickerValue';
                              currentNotifications[0] = currentNotifications[0]
                                  .copyWith(isActive: false);
                              for (var i = 0;
                                  i < currentNotifications.length;
                                  i++) {
                                if (currentNotifications[i].title ==
                                    pickerNotification) {
                                  currentNotifications[i] =
                                      currentNotifications[i]
                                          .copyWith(isActive: true);
                                }
                              }
                            }
                          });
                        },
                        child: WhiteContainerWithRoundedCorners(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Свой срок',
                                style: AppStyles.h2,
                              ),
                              if (pickerNotification != '')
                                Text(
                                  pickerNotification,
                                  style: AppStyles.h2,
                                ),
                              const Icon(
                                Icons.chevron_right_sharp,
                                size: 20,
                                color: AppTheme.mineShaft,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 26),
                      child: BlueButtonWithText(
                        text: 'Готово',
                        onPressed: () async {
                          if (!isUpdating) {
                            setState(() {
                              isUpdating = true;
                            });
                            await widget.onSendUpdate(currentNotifications);
                            setState(() {
                              isUpdating = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
