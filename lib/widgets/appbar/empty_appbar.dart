import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SystemUiOverlayStyle overlayStyle;
  final Color bgColor;

  @override
  Size get preferredSize => Size.zero;

  const EmptyAppBar({
    this.overlayStyle = SystemUiOverlayStyle.dark,
    this.bgColor = Colors.transparent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        toolbarHeight: 0,
        systemOverlayStyle: overlayStyle,
      ),
    );
  }
}
