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
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(10),
      ),
      child: Text(
        title,
        style: AppStyles.h2Bold,
      ),
    );
  }
}
