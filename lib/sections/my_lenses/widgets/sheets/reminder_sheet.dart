import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/order_registration/widgets/single_picker_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class ReminderSheet extends StatefulWidget {
  final Map<String, bool> valuesMap;
  final String customValue;
  final void Function(Map<String, bool> valuesList, String custom) onSendUpdate;
  const ReminderSheet({
    required this.valuesMap,
    required this.onSendUpdate,
    required this.customValue,
    Key? key,
  }) : super(key: key);

  @override
  State<ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends State<ReminderSheet> {
  final customNotifications = ['1 день', '2 дня', '3 дня', '4 дня', '5 дней'];
  Map<String, bool> currentValues = {};
  String customNotification = '';

  @override
  void initState() {
    currentValues.addAll(widget.valuesMap);
    customNotification = widget.customValue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
                padding: const EdgeInsets.only(bottom: 40),
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
                  const Text(
                    'Напомнить о замене',
                    style: AppStyles.h1,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentValues['Нет'] = true;
                        currentValues['В день замены'] = false;
                        currentValues['За 1 день'] = false;
                        currentValues['За 2 дня'] = false;
                        currentValues['За неделю'] = false;
                        customNotification = '';
                      });
                      widget.onSendUpdate(currentValues, customNotification);
                    },
                    child: const Text(
                      'Сбросить',
                      style: AppStyles.h3,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 14),
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
                        value: currentValues['Нет'],
                        onChanged: (value) {
                          currentValues['Нет'] = value!;
                          if (value) {
                            setState(() {
                              currentValues['В день замены'] = false;
                              currentValues['За 1 день'] = false;
                              currentValues['За 2 дня'] = false;
                              currentValues['За неделю'] = false;
                              customNotification = '';
                            });
                          }
                        },
                        borderRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
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
                        const Flexible(
                          child: Text(
                            'В день замены',
                            style: AppStyles.h2,
                          ),
                        ),
                        CustomCheckbox(
                          value: currentValues['В день замены'],
                          onChanged: (value) {
                            currentValues['В день замены'] = value!;
                            if (value) {
                              setState(() {
                                currentValues['Нет'] = false;
                              });
                            }
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
                            value: currentValues['За 1 день'],
                            onChanged: (value) {
                              currentValues['За 1 день'] = value!;
                              if (value) {
                                setState(() {
                                  currentValues['Нет'] = false;
                                });
                              }
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
                          value: currentValues['За 2 дня'],
                          onChanged: (value) {
                            currentValues['За 2 дня'] = value!;
                            if (value) {
                              setState(() {
                                currentValues['Нет'] = false;
                              });
                            }
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
                          value: currentValues['За неделю'],
                          onChanged: (value) {
                            currentValues['За неделю'] = value!;
                            if (value) {
                              setState(() {
                                currentValues['Нет'] = false;
                              });
                            }
                          },
                          borderRadius: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: GestureDetector(
                  onTap: () async {
                    final pickerValue = await showModalBottomSheet<String?>(
                          context: context,
                          builder: (context) {
                            return SinglePickerScreen(
                              title: 'Напомнить за',
                              variants: customNotifications,
                              cancelTitle: 'Отмена',
                              onCancelTap: () {
                                setState(() {
                                  customNotification = '';
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
                        customNotification = 'За $pickerValue';
                        currentValues['Нет'] = false;
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
                        if (customNotification != '')
                          Text(
                            customNotification,
                            style: AppStyles.h2,
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
                  onPressed: () =>
                      widget.onSendUpdate(currentValues, customNotification),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
