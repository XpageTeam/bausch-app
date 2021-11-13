import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  const BlueButton({
    required this.children,
    this.padding = const EdgeInsets.symmetric(vertical: 20),
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: AppTheme.turquoiseBlue,
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
