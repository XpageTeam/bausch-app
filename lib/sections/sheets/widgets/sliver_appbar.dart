import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class CustomSliverAppbar extends StatelessWidget {
  final Widget? icon;

  final EdgeInsets? padding;

  final Color iconColor;

  final ScrollController? scrollController;

  final bool colorAnimated;

  const CustomSliverAppbar({
    this.icon,
    this.padding,
    this.colorAnimated = true,
    this.iconColor = Colors.white,
    this.scrollController,
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
      child: NotificationListener<ScrollNotification>(
        child: Navigator.of(context).canPop()
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  icon ??
                      NormalIconButton(
                        isAnimated: colorAnimated,
                        padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          size: 20,
                          color: AppTheme.mineShaft,
                        ),
                        // backgroundColor: iconColor,
                        backgroundColor: iconColor,
                      ),
                  NormalIconButton(
                    isAnimated: colorAnimated,
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
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
                    backgroundColor: iconColor,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  NormalIconButton(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    isAnimated: colorAnimated,
                    onPressed: () {
                      if (Keys.mainContentNav.currentState?.canPop() ?? false) {
                        Keys.mainContentNav.currentState!.pop();
                      } else {
                        // Keys.bottomNav.currentState?.maybePop();
                        Keys.mainNav.currentState?.maybePop();
                        // Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppTheme.mineShaft,
                    ),
                    backgroundColor: iconColor,
                  ),
                ],
              ),
      ),
    );
  }
}
