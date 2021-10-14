import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DefaultToggleButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback? onPressed;
  const DefaultToggleButton({
    required this.color,
    required this.text,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: color,
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        splashColor: AppTheme.mystic,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              text,
              style: AppStyles.h2Bold,
            ),
          ),
        ),
      ),
    );
  }
}
