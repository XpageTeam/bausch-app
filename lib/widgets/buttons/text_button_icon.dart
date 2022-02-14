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
      icon: Image.asset(
        'assets/icons/delete.png',
        height: 16,
      ),
      label: const Text(
        'Удалить адрес',
        style: AppStyles.h2,
      ),
    );
  }
}
