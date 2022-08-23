import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class ChooseTypesSheet extends StatefulWidget {
  final List<bool> typesStatus;

  final void Function(List<bool> typesStatus) onSendUpdate;
  const ChooseTypesSheet({
    required this.typesStatus,
    required this.onSendUpdate,
    Key? key,
  }) : super(key: key);

  @override
  State<ChooseTypesSheet> createState() => _ChooseTypesSheetState();
}

class _ChooseTypesSheetState extends State<ChooseTypesSheet> {
  final customNotifications = ['1 день', '2 дня', '3 дня', '4 дня', '5 дней'];
  List<bool> currentValues = [];

  @override
  void initState() {
    currentValues = [...widget.typesStatus];
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
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.mineShaft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Подбор линз',
                      style: AppStyles.h1,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.onSendUpdate([false, false, false]);
                      },
                      child: const Text(
                        'Сбросить',
                        style: AppStyles.h3,
                      ),
                    ),
                  ],
                ),
              ),
              WhiteContainerWithRoundedCorners(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomCheckbox(
                          value: currentValues[0],
                          onChanged: (value) {
                            currentValues[0] = value!;
                          },
                          borderRadius: 2,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            color: AppTheme.turquoiseBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Сферические',
                          style: AppStyles.h2,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          CustomCheckbox(
                            value: currentValues[1],
                            onChanged: (value) {
                              currentValues[1] = value!;
                            },
                            borderRadius: 2,
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: const BoxDecoration(
                              color: AppTheme.sulu,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Мультифокальные',
                            style: AppStyles.h2,
                          ),
                          const Text(
                            ' (пресбиопия)',
                            style: AppStyles.h2GreyBold,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        CustomCheckbox(
                          value: currentValues[2],
                          onChanged: (value) {
                            currentValues[2] = value!;
                          },
                          borderRadius: 2,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Торические',
                          style: AppStyles.h2,
                        ),
                        const Text(
                          ' (астигматизм)',
                          style: AppStyles.h2GreyBold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 26),
                child: BlueButtonWithText(
                  text: 'Показать 2 варианта',
                  onPressed: () => widget.onSendUpdate(currentValues),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
