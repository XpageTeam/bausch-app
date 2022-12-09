import 'package:flutter/material.dart';

class WhiteContainerWithRoundedCorners extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final Color color;
  const WhiteContainerWithRoundedCorners({
    required this.child,
    this.height,
    this.width,
    this.onTap,
    this.padding,
    this.color = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: child,
      ),
    );
  }
}
