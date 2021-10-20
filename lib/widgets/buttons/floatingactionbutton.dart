import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Widget? icon;
  final VoidCallback? onPressed;
  final String text;
  final double? topPadding;
  const CustomFloatingActionButton({
    required this.text,
    this.onPressed,
    this.icon,
    this.topPadding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.mystic,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: StaticData.sidePadding,
              right: StaticData.sidePadding,
              top: topPadding ?? 0,
            ),
            child: BlueButtonWithText(
              text: text,
              onPressed: onPressed,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            color: AppTheme.mystic,
            child: const Center(
              child: Text(
                'Имеются противопоказания, необходимо проконсультироваться со специалистом',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 16 / 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
