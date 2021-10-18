import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class WhiteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const WhiteButton({required this.text, Key? key, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.pin_drop,
                    color: AppTheme.mineShaft,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    text,
                    style: AppStyles.h2,
                  ),
                ],
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
