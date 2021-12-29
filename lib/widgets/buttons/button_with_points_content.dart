import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ButtonContent extends StatelessWidget {
  final String price;
  final MainAxisAlignment? alignment;
  final bool withIcon;
  final TextStyle? textStyle;

  const ButtonContent({
    required this.price,
    this.alignment,
    this.withIcon = true,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment ?? MainAxisAlignment.center,
      children: [
        Text(
          price,
          style: textStyle ?? AppStyles.h2,
        ),
        if (withIcon)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: CircleAvatar(
              child: Text(
                'б',
                style: TextStyle(
                  color: AppTheme.mineShaft,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  height: 20 / 17,
                ),
              ),
              radius: 14,
              backgroundColor: AppTheme.turquoiseBlue,
            ),
          ),
      ],
    );
  }
}
