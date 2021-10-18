import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomTextButtonIcon extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomTextButtonIcon({required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      icon: const Icon(
        Icons.clean_hands,
        color: AppTheme.mineShaft,
        size: 20,
      ),
      label: const Text(
        'Удалить адрес',
        style: AppStyles.h2,
      ),
    );
  }
}
