import 'package:bausch/sections/order_registration/widgets/margin.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OrderButton extends StatelessWidget {
  final Widget title;
  final Color textColor;
  final EdgeInsets margin;
  final IconData? icon;
  final String? subtitle;
  final VoidCallback? onPressed;
  const OrderButton({
    required this.title,
    this.textColor = AppTheme.mineShaft,
    this.margin = EdgeInsets.zero,
    this.icon,
    this.subtitle,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Margin(
      margin: margin,
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          splashColor: AppTheme.mystic,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onPressed,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (icon != null)
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: Icon(
                            icon,
                            color: textColor,
                          ),
                        ),
                      title
                      // Text(
                      //   title,
                      //   style: AppStyles.h2Bold.copyWith(color: textColor),
                      // ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_sharp,
                  color: textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Пытался сделать кнопку, которая бы подходила под все кнопки ...
class DefaultButton extends StatelessWidget {
  final List<Widget> children;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final Color? chevronColor;
  final EdgeInsets margin;

  const DefaultButton({
    required this.children,
    this.backgroundColor = Colors.white,
    this.margin = EdgeInsets.zero,
    this.onPressed,
    this.chevronColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Margin(
      margin: margin,
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: backgroundColor,
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          splashColor: AppTheme.mystic,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onPressed,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 26, 12, 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: chevronColor != null
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: children,
                    ),
                  ),
                  if (chevronColor != null)
                    Icon(
                      Icons.chevron_right_sharp,
                      color: chevronColor,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
