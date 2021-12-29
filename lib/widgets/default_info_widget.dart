import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DefaultInfoWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onPressed;

  const DefaultInfoWidget({
    required this.title,
    this.subtitle,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppStyles.h2Bold,
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: AppStyles.p1Grey,
          ),
        if (onPressed != null)
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: BlueButton(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                Text(
                  'Повторить',
                  style: AppStyles.p1,
                ),
              ],
              onPressed: onPressed,
            ),
          ),
      ],
    );
  }
}
