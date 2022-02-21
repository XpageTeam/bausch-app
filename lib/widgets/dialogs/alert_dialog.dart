import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback yesCallback;
  final VoidCallback? noCallback;
  final String? text;
  final String? yesText;
  final String? noText;
  const CustomAlertDialog({
    required this.yesCallback,
    this.noCallback,
    this.text,
    this.yesText,
    this.noText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 40,
          left: StaticData.sidePadding,
          right: StaticData.sidePadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 38,
              decoration: BoxDecoration(
                color: AppTheme.mineShaft,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  text ?? 'Удалить адрес?',
                  style: AppStyles.h1,
                ),
              ),
            ),
            BlueButtonWithText(
              text: yesText ?? 'Да',
              onPressed: yesCallback,
            ),
            const SizedBox(
              height: 4,
            ),
            if (noCallback != null)
              SizedBox(
                height: 60,
                //width: MediaQuery.of(context).size.width - StaticData.sidePadding * 2,
                child: TextButton(
                  onPressed: noCallback,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        noText ?? 'Нет',
                        style: AppStyles.h2,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
