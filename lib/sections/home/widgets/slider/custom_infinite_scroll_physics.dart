import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomInfiniteScrollPhysics extends AlwaysScrollableScrollPhysics {
  final double ininitalOffset;
  final int itemsOnPage;
  final int additionalItems;
  const CustomInfiniteScrollPhysics({
    required this.ininitalOffset,
    required this.itemsOnPage,
    required this.additionalItems,
    ScrollPhysics? parent,
  }) : super(parent: parent);
  @override
  CustomInfiniteScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomInfiniteScrollPhysics(
      parent: buildParent(ancestor),
      itemsOnPage: itemsOnPage,
      ininitalOffset: ininitalOffset,
      additionalItems: additionalItems,
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final tolerance = this.tolerance;

    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return CustomInfiniteScrollSimulation(
        0.135,
        position.pixels,
        velocity,
        position.maxScrollExtent,
        triggerOffset: ininitalOffset,
        itemsOnPage: itemsOnPage,
        additionalItems: additionalItems,
      );
    }
    return null;
  }
}

class CustomInfiniteScrollSimulation extends FrictionSimulation {
  final double trailingExtent;
  final double triggerOffset;
  final int itemsOnPage;
  final int additionalItems;

  CustomInfiniteScrollSimulation(
    double drag,
    double position,
    double velocity,
    this.trailingExtent, {
    required this.triggerOffset,
    required this.itemsOnPage,
    required this.additionalItems,
  }) : super(drag, position, velocity);

  @override
  double x(double time) {
    final _superX = super.x(time);
    var add = 0.0;

    final val =
        triggerOffset * (additionalItems * 2 - itemsOnPage) / additionalItems;

    if (dx(time) < 0) {
      add = val;
    }

    // x = 3 / 2 при additionalItems=2 и itemsOnPage=1
    // x = 1 при additionalItems=2 и itemsOnPage=2
    // x = ? 0.5 при additionalItems=2 и itemsOnPage=3
    // кажется, теперь x это (additionalItems * 2 - itemsOnPage) / additionalItems

    final _x = (_superX - add) % (trailingExtent - val) + add;

    return _x;
  }

  @override
  bool isDone(double time) {
    return dx(time).abs() < 1;
  }
}
