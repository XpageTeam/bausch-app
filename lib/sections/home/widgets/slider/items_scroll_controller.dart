import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class ItemsScrollController extends ScrollController {
  final double initialPage;
  final int intemsOnPage;
  final double viewportFraction;
  late double oldPage = initialPage;

  double? get page {
    final position = this.position as _ItemsScrollPosition;
    return position.page;
  }

  int get direction => (position as _ItemsScrollPosition).direction;

  bool get _isCurrentPageCorrect {
    final fractionalPart = page! - page! ~/ 1;

    for (var i = 0; i <= intemsOnPage; i++) {
      final val = i / intemsOnPage - fractionalPart;
      if (val.abs() < 0.0001) {
        return true;
      }
    }

    return false;
  }

  ItemsScrollController({
    required this.intemsOnPage,
    this.initialPage = 0,
    this.viewportFraction = 1.0,
  }) : assert(viewportFraction > 0.0);

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _ItemsScrollPosition(
      physics: physics,
      context: context,
      initialPage: initialPage,
      viewportFraction: viewportFraction,
    );
  }

  @override
  void attach(ScrollPosition position) {
    super.attach(position);
    (position as _ItemsScrollPosition).viewportFraction = viewportFraction;
  }

  Future<void> animateToPageDouble(
    double page, {
    required Duration duration,
    required Curve curve,
  }) {
    final position = this.position as _ItemsScrollPosition;
    return position.animateTo(
      position.getPixelsFromPage(page),
      duration: duration,
      curve: curve,
    );
  }

  // Формула -> page! + x,
  // где x = (y-pixels).abs(),
  // где y - ближайший номер страницы,
  // который больше текущего, если нажат правый индикатор
  // и меньше текущего, если нажат левый индикатор
  Future<void> nextPageDouble({
    required Duration duration,
    required Curve curve,
  }) {
    final rawPage = page!;
    final nearestPage = getNearestGreaterPage();
    final correctValue = _isCurrentPageCorrect ? 1 : nearestPage - rawPage;

    return animateToPageDouble(
      rawPage + correctValue,
      duration: duration,
      curve: curve,
    );
  }

  double getNearestGreaterPage() {
    final rawPage = page!;
    final integerPart = rawPage ~/ 1;

    for (var i = 1; i < intemsOnPage; i++) {
      if (integerPart + i / intemsOnPage > rawPage) {
        return integerPart + i / intemsOnPage;
      }
    }

    return rawPage.ceilToDouble();
  }

  double getNearestSmallerPage() {
    final rawPage = page!;
    final integerPart = rawPage ~/ 1;

    for (var i = intemsOnPage - 1; i >= 0; i--) {
      if (integerPart + i / intemsOnPage < rawPage) {
        return integerPart + i / intemsOnPage;
      }
    }

    return 0.0;
  }

  Future<void> previousPageDouble({
    required Duration duration,
    required Curve curve,
  }) {
    final rawPage = page!;
    final nearestPage = getNearestSmallerPage();
    final correctValue = _isCurrentPageCorrect ? -1 : nearestPage - rawPage;

    return animateToPageDouble(
      rawPage + correctValue,
      duration: duration,
      curve: curve,
    );
  }
}

class _ItemsScrollPosition extends ScrollPositionWithSingleContext {
  final double initialPage;
  late double initialOffset = getPixelsFromPage(
    initialPage,
  );
  late double oldPixels = initialOffset;

  double viewportFraction;
  int direction = 0;

  double get page {
    return getPageFromPixels(
      pixels,
      viewportDimension,
    );
  }

  _ItemsScrollPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    required this.initialPage,
    required this.viewportFraction,
  }) : super(
          physics: physics,
          context: context,
        );

  // Переопределил этот метод для того, чтобы реализовать
  // "зацикленность"
  @override
  double setPixels(double newPixels) {
    updateDirection(newPixels);

    final triggerOffset = viewportDimension * viewportFraction;
    var _newPixels = newPixels;

    // Движение вправо
    // ..[......]
    if (direction > 0 && _newPixels > triggerOffset) {
      _newPixels =
          ((newPixels - triggerOffset) % (maxScrollExtent - triggerOffset) +
                  triggerOffset) %
              maxScrollExtent;
    }

    // Движение влево
    // [......]..
    if (direction < 0 && _newPixels < maxScrollExtent - triggerOffset) {
      _newPixels = newPixels % (maxScrollExtent - triggerOffset);
    }

    return super.setPixels(_newPixels);
  }

  // Переопределил этот метод для того, чтобы установить initialOffset
  @override
  bool applyViewportDimension(double viewportDimension) {
    final result = super.applyViewportDimension(viewportDimension);
    correctPixels(initialOffset);

    return result;
  }

  /// Обновление текущего направления при скроллинге
  /// и animateTo.
  void updateDirection(double newPixels) {
    if (userScrollDirection == ScrollDirection.reverse ||
        newPixels > oldPixels) {
      direction = 1;
    } else if (userScrollDirection == ScrollDirection.forward ||
        newPixels < oldPixels) {
      direction = -1;
    }
    oldPixels = newPixels;
  }

  /// Преобразование текущих пикселей в порядковый номер страницы
  double getPageFromPixels(double pixels, double viewportDimension) {
    final actual = pixels / (viewportDimension * viewportFraction);
    // final actual = double.parse(
    //   (pixels / (viewportDimension * viewportFraction)).toStringAsFixed(5),
    // );

    return actual;
  }

  /// Преобразование текущей страницы в пиксели
  double getPixelsFromPage(double page) {
    return page * viewportDimension * viewportFraction;
  }
}
