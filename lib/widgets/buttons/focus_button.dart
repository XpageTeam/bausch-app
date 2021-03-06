import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class FocusButton extends StatelessWidget {
  final String labelText;
  final String? selectedText;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  const FocusButton({
    required this.labelText,
    this.selectedText,
    this.icon,
    this.onPressed,
    this.backgroundColor = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: selectedText == null
                  ? const EdgeInsets.only(top: 26, bottom: 28)
                  : const EdgeInsets.only(top: 10, bottom: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    labelText,
                    style: selectedText == null
                        ? AppStyles.h2GreyBold
                        : AppStyles.p1Grey,
                  ),
                  if (selectedText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        selectedText!,
                        style: AppStyles.h2,
                      ),
                    ),
                ],
              ),
            ),
          ),
          icon ??
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
