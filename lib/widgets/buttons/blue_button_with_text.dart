import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class BlueButtonWithText extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  const BlueButtonWithText({
    required this.text,
    this.onPressed,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      //width: MediaQuery.of(context).size.width - StaticData.sidePadding * 2,
      child: TextButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: onPressed == null
              ? AppTheme.turquoiseBlue.withOpacity(0.5)
              : AppTheme.turquoiseBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Container(
                margin: const EdgeInsets.only(right: 9),
                child: icon,
              ),
            Flexible(
              child: Text(
                text,
                style: AppStyles.h2.copyWith(
                  color: onPressed == null
                      ? AppTheme.mineShaft.withOpacity(0.5)
                      : AppTheme.mineShaft,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
