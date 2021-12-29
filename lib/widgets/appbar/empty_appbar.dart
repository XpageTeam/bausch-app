import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewEmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SystemUiOverlayStyle overlayStyle;
  final Color appBarBgColor;
  final Color? scaffoldBgColor;

  @override
  Size get preferredSize => Size.zero;

  const NewEmptyAppBar({
    this.overlayStyle = SystemUiOverlayStyle.dark,
    this.appBarBgColor = Colors.transparent,
    this.scaffoldBgColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = scaffoldBgColor ??
        // Scaffold.of(context).widget.backgroundColor ??
        Colors.white;
    final value = color.red * 0.3 + color.green * 0.59 + color.blue * 0.11;

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

@Deprecated('Перестать использовать')
class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SystemUiOverlayStyle overlayStyle;

  @override
  Size get preferredSize => Size.zero;
  
  @Deprecated('Перестать использовать')
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
        backgroundColor: Colors.white,
        toolbarHeight: 0,
        systemOverlayStyle: overlayStyle,
      ),
    );
  }
}
