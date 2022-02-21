import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NormalIconButton extends StatelessWidget {
  final Widget icon;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final bool isAnimated;
  const NormalIconButton({
    required this.icon,
    this.isAnimated = true,
    this.backgroundColor = Colors.white,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isAnimated
        ? AnimatedContainer(
            height: 44,
            width: 44,
            duration: const Duration(
              milliseconds: 300,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Material(
              clipBehavior: Clip.hardEdge,
              shape: const CircleBorder(),
              child: InkWell(
                splashColor: AppTheme.turquoiseBlue,
                onTap: onPressed,
                child: icon,
              ),
              color: Colors.transparent,
            ),
          )
        : Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Material(
              clipBehavior: Clip.hardEdge,
              shape: const CircleBorder(),
              child: InkWell(
                splashColor: AppTheme.turquoiseBlue,
                onTap: onPressed,
                child: icon,
              ),
              color: Colors.transparent,
            ),
          );
  }
}
