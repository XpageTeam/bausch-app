import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
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
  final List<String> reminders;
  final bool multiDayLife;
  final Future<void> Function(List<String>) onSendUpdate;
  const ReminderSheet({
    required this.reminders,
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
  List<bool> boolValues = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  bool isUpdating = false;

  @override
  void initState() {
    if (widget.reminders.isEmpty) {
      boolValues[0] = true;
    } else {
      for (final element in widget.reminders) {
        switch (element) {
          case '0':
            boolValues[1] = true;
            break;
          case '1':
            boolValues[2] = true;
            break;
          case '2':
            boolValues[3] = true;
            break;
          case '3':
            boolValues[4] = true;
            break;
          case '4':
            boolValues[5] = true;
            break;
          case '5':
            boolValues[6] = true;
            break;
          case '7':
            boolValues[7] = true;
            break;
        }
      }
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
                            if (!isUpdating) {
                              setState(() {
                                isUpdating = true;
                              });
                              await widget.onSendUpdate([]);
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
                                value: boolValues[0],
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      for (var i = 1;
                                          i < boolValues.length;
                                          i++) {
                                        boolValues[i] = false;
                                      }
                                      boolValues[0] = true;
                                      pickerNotification = '';
                                    } else {
                                      boolValues[0] = false;
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
                                value: boolValues[1],
                                onChanged: (value) {
                                  setState(() {
                                    boolValues[1] = value!;
                                    if (value) {
                                      boolValues[0] = false;
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
                                  value: boolValues[2],
                                  onChanged: (value) {
                                    setState(() {
                                      boolValues[2] = value!;
                                      if (value) {
                                        boolValues[0] = false;
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
                                value: boolValues[3],
                                onChanged: (value) {
                                  setState(() {
                                    boolValues[3] = value!;
                                    if (value) {
                                      boolValues[0] = false;
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
                                value: boolValues[7],
                                onChanged: (value) {
                                  setState(() {
                                    boolValues[7] = value!;
                                    if (value) {
                                      boolValues[0] = false;
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
                              boolValues[0] = false;
                              boolValues[int.parse(pickerValue[0]) + 1] = true;
                            }
                          });
                        },
                        child: WhiteContainerWithRoundedCorners(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Свой срок', style: AppStyles.h2),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                            final result = <String>[];
                            for (var i = 1; i < boolValues.length; i++) {
                              if (boolValues[i]) {
                                result.add((i != 7 ? i - 1 : i).toString());
                              }
                            }
                            await widget.onSendUpdate(result);
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
