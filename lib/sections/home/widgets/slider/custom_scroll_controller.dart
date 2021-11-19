import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomScrollController extends ScrollController {
  final double triggerOffset;
  final int pagesCount;
  final double viewportDim;

  int get page => (position as CustomScrollPosition).page;
  // TODO(Nikolay): Реализовать получение направления.
  ScrollDirection get direction =>
      (position as CustomScrollPosition).userScrollDirection;
  int get distance {
    final dist = (page - _oldPage).abs();
    _oldPage = page;
    return dist;
  }

  int _oldPage = 0;

  CustomScrollController({
    required double initialScrollOffset,
    required this.pagesCount,
    required this.triggerOffset,
    required this.viewportDim,
  }) : super(
          initialScrollOffset: initialScrollOffset,
        );

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    var pos = CustomScrollPosition(
      physics: physics,
      context: context,
      triggerOffset: triggerOffset,
      initialScrollOffset: initialScrollOffset,
      viewportDim: viewportDim,
    );

    return pos;
  }

  Future<void> animateToPage(
    int page, {
    required Duration duration,
    required Curve curve,
  }) {
    // final _PagePosition position = this.position as _PagePosition;
    return position.animateTo(
      page * viewportDim,
      duration: duration,
      curve: curve,
    );
  }

  Future<void> nextPage() {
    return animateToPage(
      page + 1,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeOutQuart,
    );
  }

  Future<void> previousPage() {
    return animateToPage(
      page - 1,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeOutQuart,
    );
  }
}

class CustomScrollPosition extends ScrollPositionWithSingleContext {
  final double triggerOffset;
  double oldPixels;
  double oldPixels2;

  double viewportDim;

  CustomScrollPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    required this.triggerOffset,
    required this.viewportDim,
    required double initialScrollOffset,
  })  : oldPixels = initialScrollOffset,
        oldPixels2 = initialScrollOffset,
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

  int get page => double.parse(
        (pixels / viewportDim).toStringAsFixed(5),
      ).round();
}
