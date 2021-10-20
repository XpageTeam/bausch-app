import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ShopFilterButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isSelected;
  const ShopFilterButton({
    required this.title,
    this.onPressed,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Colors.white : AppTheme.mystic,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        splashColor: AppTheme.turquoiseBlue,
        hoverColor: AppTheme.grey,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title,
            style: AppStyles.h2Bold,
          ),
        ),
      ),
    );
  }
}
