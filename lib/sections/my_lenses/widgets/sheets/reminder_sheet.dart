import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class ReminderSheet extends StatefulWidget {
  final List<String> currentReminders;
  final bool multiDayLife;
  final Future<void> Function(List<String>) onSendUpdate;
  const ReminderSheet({
    required this.currentReminders,
    required this.onSendUpdate,
    this.multiDayLife = true,
    Key? key,
  }) : super(key: key);

  @override
  State<ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends State<ReminderSheet> {
  List<bool> boolValues = [false, false, false];

  @override
  void initState() {
    if (widget.currentReminders.isEmpty) {
      boolValues[0] = true;
    } else {
      for (final element in widget.currentReminders) {
        switch (element) {
          case '0':
            boolValues[1] = true;
            break;
          case '1':
            boolValues[2] = true;
            break;
        }
      }
    }
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
                      if (widget.multiDayLife) {
                        await widget.onSendUpdate([]);
                      } else {
                        await widget.onSendUpdate(['0']);
                      }
                    },
                    child: const Text(
                      'Сбросить',
                      style: AppStyles.h3,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 4),
                child: WhiteContainerWithRoundedCorners(
                  padding: const EdgeInsets.only(
                    left: StaticData.sidePadding,
                    top: 4,
                    bottom: 4,
                  ),
                  child: widget.multiDayLife
                      ? Row(
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
                                  } else {
                                    boolValues[0] = false;
                                  }
                                });
                              },
                              borderRadius: 2,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Flexible(
                              child: Text(
                                'В день покупки',
                                style: AppStyles.h2,
                              ),
                            ),
                            CustomCheckbox(
                              value: boolValues[1],
                              onChanged: (value) {
                                setState(() {
                                  boolValues[1] = value!;
                                });
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
                    if (widget.multiDayLife)
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 26),
                child: BlueButtonWithText(
                  text: 'Готово',
                  onPressed: () async {
                    final result = <String>[];
                    for (var i = 1; i < boolValues.length; i++) {
                      if (boolValues[i]) {
                        result.add((i - 1).toString());
                      }
                    }
                    if (result.isEmpty && !widget.multiDayLife) {
                      result.add('0');
                    }
                    await widget.onSendUpdate(result);
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
