import 'package:bausch/sections/order_registration/widgets/margin.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class MarkedTextRow extends StatelessWidget {
  final String text;
  const MarkedTextRow({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Margin(
          margin: const EdgeInsets.only(right: 14),
          child: Text(
            '•',
            style: AppStyles.p1.copyWith(
              color: AppTheme.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppStyles.p1.copyWith(
              color: AppTheme.grey,
            ),
          ),
        ),
      ],
    );
  }
}
