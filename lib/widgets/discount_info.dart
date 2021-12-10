import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DiscountInfo extends StatelessWidget {
  final String text;
  final Color? color;
  const DiscountInfo({required this.text, this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? AppTheme.sulu,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: AppStyles.h2,
      ),
    );
  }
}
