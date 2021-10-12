import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BlueButtonWithText extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const BlueButtonWithText({required this.text, this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      //width: MediaQuery.of(context).size.width - StaticData.sidePadding * 2,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: AppTheme.turquoiseBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppStyles.h2,
            ),
          ],
        ),
      ),
    );
  }
}
