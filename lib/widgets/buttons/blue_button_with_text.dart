import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: onPressed == null
              ? AppTheme.turquoiseBlue.withOpacity(0.5)
              : AppTheme.turquoiseBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Container(),
            Padding(
              padding: EdgeInsets.only(left: icon == null ? 0 : 9),
              child: Text(
                text,
                style: AppStyles.h2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
