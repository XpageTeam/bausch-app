import 'package:flutter/material.dart';

class CustomScrollController extends ScrollController {
  final double triggerOffset;

  CustomScrollController({
    required double initialScrollOffset,
    required this.triggerOffset,
  }) : super(
          initialScrollOffset: initialScrollOffset,
        );

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return CustomScrollPosition(
      physics: physics,
      context: context,
      triggerOffset: triggerOffset,
      initialScrollOffset: initialScrollOffset,
    );
  }
}

class CustomScrollPosition extends ScrollPositionWithSingleContext {
  final double triggerOffset;
  double oldPixels;

  CustomScrollPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    required this.triggerOffset,
    required double initialScrollOffset,
  })  : oldPixels = initialScrollOffset,
        super(
          physics: physics,
          context: context,
          initialPixels: initialScrollOffset,
          keepScrollOffset: true,
        );

  @override
  double setPixels(double newPixels) {
    var _newPixels = newPixels;

    // Движение вправо
    // ..[......]
    if (newPixels > oldPixels && _newPixels > triggerOffset) {
      _newPixels =
          ((newPixels - triggerOffset) % (maxScrollExtent - triggerOffset) +
                  triggerOffset) %
              maxScrollExtent;
    }

    // Движение влево
    // [......]..
    if (newPixels < oldPixels && _newPixels < maxScrollExtent - triggerOffset) {
      _newPixels = newPixels % (maxScrollExtent - triggerOffset);
    }
    
    oldPixels = newPixels;

    return super.setPixels(_newPixels);
  }
}
