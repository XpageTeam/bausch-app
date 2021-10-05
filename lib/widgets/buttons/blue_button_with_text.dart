import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';

class BlueButtonWithText extends StatelessWidget {
  final String text;
  const BlueButtonWithText({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width - StaticData.sidePadding * 2,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          //primary: AppTheme.turquoiseBlue,
          backgroundColor: AppTheme.turquoiseBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppStyles.h3,
            )
          ],
        ),
      ),
    );
  }
}
