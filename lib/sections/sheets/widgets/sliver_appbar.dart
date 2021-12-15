import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomSliverAppbar extends StatelessWidget {
  final Widget? icon;
  final Color? iconColor;
  final EdgeInsets? padding;
  final GlobalKey<NavigatorState> rightKey;
  final GlobalKey<NavigatorState> leftKey;
  const CustomSliverAppbar({
    required this.rightKey,
    required this.leftKey,
    this.icon,
    this.iconColor,
    this.padding,
    Key? key,
  }) : super(key: key);

  CustomSliverAppbar.toPop({
    required Widget icon,
    Key? key,
    GlobalKey<NavigatorState>? rightKey,
    Color? backgroundColor,
  }) : this(
          rightKey: rightKey ?? Keys.bottomSheetItemsNav,
          leftKey: Keys.bottomSheetWithoutItemsNav,
          icon: icon,
          iconColor: backgroundColor ?? AppTheme.mystic,
          key: key,
        );

  CustomSliverAppbar.toClose(Widget icon, Key? key)
      : this(
          rightKey: Keys.mainNav,
          leftKey: Keys.bottomSheetWithoutItemsNav,
          icon: icon,
          iconColor: AppTheme.mystic,
          key: key,
        );

  CustomSliverAppbar.toCloseAndPop(
    Key? key, {
    Color? backgroundColor,
    EdgeInsets? padding,
  }) : this(
          rightKey: Keys.mainNav,
          leftKey: Keys.bottomSheetWithoutItemsNav,
          iconColor: backgroundColor ?? AppTheme.mystic,
          key: key,
          padding: padding,
        );

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
                    leftKey.currentState!.pop();
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
                rightKey.currentState!.pop();
              },
              icon: const Icon(
                Icons.close,
                size: 20,
                color: AppTheme.mineShaft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
