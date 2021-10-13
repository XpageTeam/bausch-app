import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomSliverAppbar extends StatelessWidget {
  final Widget? icon;
  final Color? iconColor;
  final EdgeInsets? padding;
  const CustomSliverAppbar({this.icon, this.iconColor, this.padding, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.only(
            top: 6,
            right: 6,
            left: 6,
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon ??
              CircleAvatar(
                radius: 22,
                backgroundColor: iconColor ?? Colors.white,
                child: IconButton(
                  onPressed: () {
                    Keys.bottomSheetNav.currentState!.pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppTheme.mineShaft,
                  ),
                ),
              ),
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor ?? Colors.white,
            child: IconButton(
              onPressed: () {
                if (icon == null) {
                  Navigator.of(Keys.mainNav.currentContext!).pop();
                } else {
                  Navigator.of(Keys.bottomSheetNav.currentContext!).pop();
                }
              },
              icon: const Icon(
                Icons.close,
                color: AppTheme.mineShaft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
