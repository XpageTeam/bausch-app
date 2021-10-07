import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Widget? topRightWidget;
  final Color backgroundColor;
  const DefaultAppBar({
    required this.title,
    this.topRightWidget,
    this.backgroundColor = AppTheme.turquoiseBlue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Material(
        color: backgroundColor,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Navigator.of(context).canPop() == false //!
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: NormalIconButton(
                          onPressed: () {}, //Navigator.of(context).pop,
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
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: topRightWidget != null ? topRightWidget! : Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 48);
}
