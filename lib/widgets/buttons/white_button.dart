import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class WhiteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  const WhiteButton({
    required this.text,
    this.icon,
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
        child: Flexible(
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
                        style: AppStyles.h2,
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
