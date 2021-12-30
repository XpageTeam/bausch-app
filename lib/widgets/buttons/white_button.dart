import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class WhiteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final EdgeInsets? padding;
  final TextStyle? style;

  const WhiteButton({
    required this.text,
    this.style,
    this.icon,
    this.padding,
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    icon ??
                        Row(
                          children: const [
                            Icon(
                              Icons.pin_drop,
                              color: AppTheme.mineShaft,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                    Flexible(
                      child: Text(
                        text,
                        style: style ?? AppStyles.h2,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_sharp,
                color: AppTheme.mineShaft,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
