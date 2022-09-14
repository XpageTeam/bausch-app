import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/white_button_with_text.dart';
import 'package:flutter/material.dart';

class PutOnEndSheet extends StatelessWidget {
  final VoidCallback onLeftConfirmed;
  final VoidCallback onRightConfirmed;
  final VoidCallback onBothConfirmed;
  const PutOnEndSheet({
    required this.onBothConfirmed,
    required this.onLeftConfirmed,
    required this.onRightConfirmed,
    Key? key,
  }) : super(key: key);

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
            bottom: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.mineShaft,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Завершить ношение',
                      style: AppStyles.h1,
                    ),
                    GestureDetector(
                      onTap: Navigator.of(context).pop,
                      child: const Text(
                        'Отменить',
                        style: AppStyles.h3,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: WhiteButtonWithText(
                      text: 'L ∙ Левой линзы',
                      onPressed: onLeftConfirmed,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                    child: WhiteButtonWithText(
                      text: 'R ∙ Правой линзы',
                      onPressed: onRightConfirmed,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                    child: BlueButtonWithText(
                      text: 'Обеих линз',
                      onPressed: onBothConfirmed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
