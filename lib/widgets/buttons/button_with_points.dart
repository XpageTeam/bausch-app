import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';

class ButtonWithPoints extends StatelessWidget {
  final String price;
  const ButtonWithPoints({required this.price, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        primary: AppTheme.grey,
        backgroundColor: AppTheme.mystic,
      ),
      child: ButtonContent(price: price),
    );
  }
}
