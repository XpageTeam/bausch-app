import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ShopFilterButton extends StatelessWidget {
  final Filter filter;
  final void Function(Filter filter) onPressed;
  final bool isSelected;

  const ShopFilterButton({
    required this.filter,
    required this.onPressed,
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
      child: GestureDetector(
        onTap: () => onPressed(filter),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            filter.title,
            style: AppStyles.h2Bold,
          ),
        ),
      ),
    );
  }
}
