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
