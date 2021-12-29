import 'package:flutter/material.dart';

class IndicatorsScrollController extends ScrollController {
  final double triggerOffset;
  final double viewportDim;

  int get page => (position as _IndicatorScrollPosition).page;
  int get distance {
    final dist = (page - _oldPage).abs();
    _oldPage = page;
    return dist;
  }

  int _oldPage = 0;

  IndicatorsScrollController({
    required double initialScrollOffset,
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
    final pos = _IndicatorScrollPosition(
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

class _IndicatorScrollPosition extends ScrollPositionWithSingleContext {
  final double triggerOffset;
  double oldPixels;

  double viewportDim;

  int get page {
    final _page = double.parse(
      (pixels / viewportDim).toStringAsFixed(5),
    ).round();

    return _page;
  }

  _IndicatorScrollPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    required this.triggerOffset,
    required this.viewportDim,
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
