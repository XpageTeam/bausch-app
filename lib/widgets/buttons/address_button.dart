import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class AddressButton extends StatelessWidget {
  final String labelText;
  final String? selectedText;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  const AddressButton({
    required this.labelText,
    this.selectedText,
    this.onPressed,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: selectedText == null
                  ? const EdgeInsets.only(top: 26, bottom: 28)
                  : const EdgeInsets.only(top: 14, bottom: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelText,
                    style: AppStyles.h2,
                  ),
                  if (selectedText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        selectedText!,
                        style: AppStyles.p1.copyWith(
                          color: AppTheme.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_sharp,
            size: 20,
            color:
                // selectedText == null ? AppTheme.grey :
                AppTheme.mineShaft,
          ),
        ],
      ),
    );
  }
}
