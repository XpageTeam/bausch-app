import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';

class ButtonWithPoints extends StatelessWidget {
  final String price;
  final VoidCallback onPressed;
  final bool withIcon;

  const ButtonWithPoints({
    required this.price,
    required this.onPressed,
    this.withIcon = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 46,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppTheme.grey,
          backgroundColor: AppTheme.mystic,
        ),
        child: ButtonContent(
          price: price,
          withIcon: withIcon,
        ),
      ),
    );
  }
}
