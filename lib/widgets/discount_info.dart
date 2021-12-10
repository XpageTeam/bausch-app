import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DiscountInfo extends StatelessWidget {
  final String text;
  final Color color;
  const DiscountInfo({required this.text, this.color = AppTheme.sulu, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            text,
            style: AppStyles.h2,
          ),
        ),
      ],
    );
  }
}
