import 'package:flutter/material.dart';

/// Просто обертка Container с margin
class Margin extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  const Margin({
    required this.child,
    required this.margin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: child,
    );
  }
}
