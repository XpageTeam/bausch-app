import 'package:flutter/material.dart';

class AntiGlowBehavior extends ScrollBehavior {
  const AntiGlowBehavior();

  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
