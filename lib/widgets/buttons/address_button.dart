import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class AddressButton extends StatelessWidget {
  final String labelText;
  final String selectedText;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  const AddressButton({
    required this.labelText,
    required this.selectedText,
    this.onPressed,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labelText,
                  style: AppStyles.h2Bold,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    selectedText,
                    style: AppStyles.p1Grey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_sharp,
            size: 18,
            color: AppTheme.mineShaft,
          ),
        ],
      ),
    );
  }
}
