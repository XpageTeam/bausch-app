// ignore_for_file: prefer_mixin

import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/appbar/empty_appbar.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Widget? topRightWidget;

  final Color backgroundColor;

  @override
  Size get preferredSize => const Size(double.infinity, 48);

  const DefaultAppBar({
    required this.title,
    this.topRightWidget,
    this.backgroundColor = AppTheme.turquoiseBlue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const NewEmptyAppBar(),
        SafeArea(
          bottom: false,
          child: Material(
            color: backgroundColor,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Navigator.of(context).canPop()
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: NormalIconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, //Navigator.of(context).pop,
                              icon: const Icon(
                                Icons.chevron_left_rounded,
                                size: 20,
                                color: AppTheme.mineShaft,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Text(
                        title,
                        style: AppStyles.h2Bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: topRightWidget != null
                          ? topRightWidget!
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
