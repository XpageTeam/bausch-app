import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class CustomSliverAppbar extends StatelessWidget {
  final Widget? icon;

  final EdgeInsets? padding;

  final Color iconColor;

  const CustomSliverAppbar({
    this.icon,
    this.padding,
    this.iconColor = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.only(
            top: 6,
            right: 6,
            left: 6,
          ),
      child: Navigator.of(context).canPop()
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon ??
                    NormalIconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        size: 20,
                        color: AppTheme.mineShaft,
                      ),
                      // backgroundColor: iconColor,
                      backgroundColor: AppTheme.turquoiseBlue,
                    ),
                NormalIconButton(
                  onPressed: () {
                    icon != null
                        ? Navigator.of(context).pop()
                        : Keys.mainContentNav.currentState!.pop();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: AppTheme.mineShaft,
                  ),
                  // backgroundColor: iconColor,
                  backgroundColor: AppTheme.turquoiseBlue,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                NormalIconButton(
                  onPressed: () {
                    Keys.mainContentNav.currentState!.pop();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: AppTheme.mineShaft,
                  ),
                  // backgroundColor: iconColor,
                  backgroundColor: AppTheme.turquoiseBlue,
                ),
              ],
            ),
    );
  }
}
