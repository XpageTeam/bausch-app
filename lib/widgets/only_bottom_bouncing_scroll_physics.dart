import 'package:flutter/material.dart';

class OnlyBottomBouncingScrollPhysics extends BouncingScrollPhysics {
  const OnlyBottomBouncingScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  OnlyBottomBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return OnlyBottomBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }

    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }

    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) // hit bottom edge
    {
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }
}
