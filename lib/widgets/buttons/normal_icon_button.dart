import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NormalIconButton extends StatelessWidget {
  final Widget icon;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final bool isAnimated;
  final EdgeInsets? padding;

  const NormalIconButton({
    required this.icon,
    this.isAnimated = true,
    this.backgroundColor = Colors.white,
    this.padding,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding,
        color: Colors.transparent,
        alignment: Alignment.topRight,
        child: AnimatedContainer(
          height: 44,
          width: 44,
          duration: isAnimated
              ? const Duration(
                  milliseconds: 300,
                )
              : Duration.zero,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          clipBehavior: Clip.hardEdge,
          child: Material(
            child: InkWell(
              splashColor: AppTheme.turquoiseBlue,
              highlightColor: Colors.transparent,
              onTap: onPressed,
              child: icon,
            ),
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
