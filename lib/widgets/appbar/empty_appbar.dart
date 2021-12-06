import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SystemUiOverlayStyle overlayStyle;

  @override
  Size get preferredSize => Size.zero;

  const EmptyAppBar({
    this.overlayStyle = SystemUiOverlayStyle.dark,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        systemOverlayStyle: overlayStyle,
      ),
    );
  }
}


class NewEmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SystemUiOverlayStyle overlayStyle;
  final Color scaffoldBgColor;
  final Color appBarBgColor;

  @override
  Size get preferredSize => Size.zero;

  const NewEmptyAppBar({
    required this.scaffoldBgColor,
    this.overlayStyle = SystemUiOverlayStyle.dark,
    this.appBarBgColor = Colors.transparent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = scaffoldBgColor.red * 0.3 +
        scaffoldBgColor.green * 0.59 +
        scaffoldBgColor.blue * 0.11;

    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        elevation: 0,
        backgroundColor: appBarBgColor,
        toolbarHeight: 0,
        systemOverlayStyle:
            value > 215 // Пока что эта константа точно не определена
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
      ),
    );
  }
}
