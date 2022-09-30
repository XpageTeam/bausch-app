import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Widget? icon;
  final VoidCallback? onPressed;
  final String text;
  final double? topPadding;
  final bool withInfo;
  const CustomFloatingActionButton({
    required this.text,
    this.onPressed,
    this.icon,
    this.topPadding,
    this.withInfo = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.mystic,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: StaticData.sidePadding,
              right: StaticData.sidePadding,
              bottom: withInfo ? 8 : 20,
              top: topPadding ?? 0,
            ),
            child: BlueButtonWithText(
              text: text,
              icon: icon,
              onPressed: onPressed,
            ),
          ),
          if (withInfo)
            const ColoredBox(
              color: AppTheme.mystic,
              child: BottomInfoBlock(
                topPadding: 0,
              ),
            ),
        ],
      ),
    );
  }
}
