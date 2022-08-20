import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class GreyButton extends StatelessWidget {
  final String text;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  const GreyButton({
    required this.text,
    this.rightIcon,
    this.leftIcon,
    this.onPressed,
    this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.mystic,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: padding ?? const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null) ...[
              leftIcon!,
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: AppStyles.h2,
            ),
            if (rightIcon != null) ...[
              const SizedBox(width: 10),
              rightIcon!,
            ],
          ],
        ),
      ),
    );
  }
}
