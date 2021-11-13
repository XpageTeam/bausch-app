import 'package:flutter/material.dart';

class WhiteContainerWithRoundedCorners extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? heigth;
  final double? width;
  final EdgeInsets? padding;
  const WhiteContainerWithRoundedCorners({
    required this.child,
    this.heigth,
    this.width,
    this.onTap,
    this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: heigth,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}
