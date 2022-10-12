// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OtherDraggableScrollableController extends ChangeNotifier {
  double get size {
    _assertAttached();
    return _attachedController!.extent.currentSize;
  }

  double get pixels {
    _assertAttached();
    return _attachedController!.extent.currentPixels;
  }

  _OtherDraggableScrollableSheetScrollController? _attachedController;

  double sizeToPixels(double size) {
    _assertAttached();
    return _attachedController!.extent.sizeToPixels(size);
  }

  double pixelsToSize(double pixels) {
    _assertAttached();
    return _attachedController!.extent.pixelsToSize(pixels);
  }

  Future<void> animateTo(
    double size, {
    required Duration duration,
    required Curve curve,
  }) async {
    _assertAttached();
    assert(size >= 0 && size <= 1);
    assert(duration != Duration.zero);
    final animationController = AnimationController.unbounded(
      vsync: _attachedController!.position.context.vsync,
      value: _attachedController!.extent.currentSize,
    );
    _attachedController!.position.goIdle();
    // This disables any snapping until the next user interaction with the sheet.
    _attachedController!.extent.hasDragged = false;
    _attachedController!.extent.startActivity(onCanceled: () {
      // Don't stop the controller if it's already finished and may have been disposed.
      if (animationController.isAnimating) {
        animationController.stop();
      }
    });
    animationController.addListener(() {
      _attachedController!.extent.updateSize(
        animationController.value,
        _attachedController!.position.context.notificationContext!,
      );
      if (animationController.value > _attachedController!.extent.maxSize ||
          animationController.value < _attachedController!.extent.minSize) {
        // Animation hit the max or min size, stop animating.
        animationController.stop(canceled: false);
      }
    });
    await animationController.animateTo(size, duration: duration, curve: curve);
  }

  void jumpTo(double size) {
    _assertAttached();
    assert(size >= 0 && size <= 1);
    // Call start activity to interrupt any other playing activities.
    _attachedController!.extent.startActivity(onCanceled: () {});
    _attachedController!.position.goIdle();
    _attachedController!.extent.hasDragged = false;
    _attachedController!.extent.updateSize(
      size,
      _attachedController!.position.context.notificationContext!,
    );
  }

  void reset() {
    _assertAttached();
    _attachedController!.reset();
  }

  void _assertAttached() {
    assert(
      _attachedController != null,
      'DraggableScrollableController is not attached to a sheet. A DraggableScrollableController '
      'must be used in a DraggableScrollableSheet before any of its methods are called.',
    );
  }

  void _attach(
    _OtherDraggableScrollableSheetScrollController scrollController,
  ) {
    assert(_attachedController == null,
        'Draggable scrollable controller is already attached to a sheet.');
    _attachedController = scrollController;
    _attachedController!.extent._currentSize.addListener(notifyListeners);
  }

  void _onExtentReplaced(_DraggableSheetExtent previousExtent) {
    _attachedController!.extent._currentSize.addListener(notifyListeners);
    if (previousExtent.currentSize != _attachedController!.extent.currentSize) {
      notifyListeners();
    }
  }

  void _detach() {
    _attachedController?.extent._currentSize.removeListener(notifyListeners);
    _attachedController = null;
  }
}

/// Пришлось скопировать, чтобы в нужном месте написать extent.hasDragged = false, чтобы работало как хотелось бы изначально
class OtherDraggableScrollableSheet extends StatefulWidget {
  final double initialChildSize;

  final double minChildSize;

  final double maxChildSize;

  final bool expand;

  final bool snap;

  final List<double>? snapSizes;

  final OtherDraggableScrollableController? controller;

  final ScrollableWidgetBuilder builder;

  const OtherDraggableScrollableSheet({
    required this.builder,
    Key? key,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.expand = true,
    this.snap = false,
    this.snapSizes,
    this.controller,
  })  : assert(minChildSize >= 0.0),
        assert(maxChildSize <= 1.0),
        assert(minChildSize <= initialChildSize),
        assert(initialChildSize <= maxChildSize),
        super(key: key);

  @override
  State<OtherDraggableScrollableSheet> createState() =>
      _OtherDraggableScrollableSheetState();
}

class _DraggableSheetExtent {
  final double minSize;
  final double maxSize;
  final bool snap;
  final List<double> snapSizes;
  final double initialSize;
  final VoidCallback onSizeChanged;
  final ValueNotifier<double> _currentSize;

  bool hasDragged;
  double availablePixels;

  bool get isAtMin => minSize >= _currentSize.value;
  bool get isAtMax => maxSize <= _currentSize.value;

  double get currentSize => _currentSize.value;
  double get currentPixels => sizeToPixels(_currentSize.value);

  double get additionalMinSize => isAtMin ? 0.0 : 1.0;
  double get additionalMaxSize => isAtMax ? 0.0 : 1.0;
  List<double> get pixelSnapSizes => snapSizes.map(sizeToPixels).toList();

  VoidCallback? _cancelActivity;

  _DraggableSheetExtent({
    required this.minSize,
    required this.maxSize,
    required this.snap,
    required this.snapSizes,
    required this.initialSize,
    required this.onSizeChanged,
    ValueNotifier<double>? currentSize,
    bool? hasDragged,
  })  : assert(minSize >= 0),
        assert(maxSize <= 1),
        assert(minSize <= initialSize),
        assert(initialSize <= maxSize),
        _currentSize = (currentSize ?? ValueNotifier<double>(initialSize))
          ..addListener(onSizeChanged),
        availablePixels = double.infinity,
        hasDragged = hasDragged ?? false;

  void startActivity({required VoidCallback onCanceled}) {
    _cancelActivity?.call();
    _cancelActivity = onCanceled;
  }

  void addPixelDelta(double delta, BuildContext context) {
    _cancelActivity?.call();
    _cancelActivity = null;

    hasDragged = true;
    if (availablePixels == 0) {
      return;
    }
    updateSize(currentSize + pixelsToSize(delta), context);
  }

  void updateSize(double newSize, BuildContext context) {
    _currentSize.value = newSize.clamp(minSize, maxSize);
    DraggableScrollableNotification(
      minExtent: minSize,
      maxExtent: maxSize,
      extent: currentSize,
      initialExtent: initialSize,
      context: context,
    ).dispatch(context);
  }

  double pixelsToSize(double pixels) {
    return pixels / availablePixels * maxSize;
  }

  double sizeToPixels(double size) {
    return size / maxSize * availablePixels;
  }

  void dispose() {
    _currentSize.removeListener(onSizeChanged);
  }

  _DraggableSheetExtent copyWith({
    required double minSize,
    required double maxSize,
    required bool snap,
    required List<double> snapSizes,
    required double initialSize,
    required VoidCallback onSizeChanged,
  }) {
    return _DraggableSheetExtent(
      minSize: minSize,
      maxSize: maxSize,
      snap: snap,
      snapSizes: snapSizes,
      initialSize: initialSize,
      onSizeChanged: onSizeChanged,
      // Use the possibly updated initialSize if the user hasn't dragged yet.
      currentSize: ValueNotifier<double>(hasDragged
          ? _currentSize.value.clamp(minSize, maxSize)
          : initialSize),

      hasDragged: hasDragged,
    );
  }
}

class _OtherDraggableScrollableSheetState
    extends State<OtherDraggableScrollableSheet> {
  late _OtherDraggableScrollableSheetScrollController _scrollController;
  late _DraggableSheetExtent _extent;

  @override
  void initState() {
    super.initState();
    _extent = _DraggableSheetExtent(
      minSize: widget.minChildSize,
      maxSize: widget.maxChildSize,
      snap: widget.snap,
      snapSizes: _impliedSnapSizes(),
      initialSize: widget.initialChildSize,
      onSizeChanged: _setExtent,
    );
    _scrollController =
        _OtherDraggableScrollableSheetScrollController(extent: _extent);
    widget.controller?._attach(_scrollController);
  }

  @override
  void didUpdateWidget(covariant OtherDraggableScrollableSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    _replaceExtent();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_InheritedResetNotifier.shouldReset(context)) {
      _scrollController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _extent.availablePixels =
            widget.maxChildSize * constraints.biggest.height;
        final Widget sheet = FractionallySizedBox(
          heightFactor: _extent.currentSize,
          alignment: Alignment.bottomCenter,
          child: widget.builder(context, _scrollController),
        );
        return widget.expand ? SizedBox.expand(child: sheet) : sheet;
      },
    );
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _scrollController.dispose();
    _extent.dispose();
    super.dispose();
  }

  List<double> _impliedSnapSizes() {
    for (var index = 0; index < (widget.snapSizes?.length ?? 0); index += 1) {
      final snapSize = widget.snapSizes![index];
      assert(snapSize >= widget.minChildSize && snapSize <= widget.maxChildSize,
          '${_snapSizeErrorMessage(index)}\nSnap sizes must be between `minChildSize` and `maxChildSize`. ');
      assert(index == 0 || snapSize > widget.snapSizes![index - 1],
          '${_snapSizeErrorMessage(index)}\nSnap sizes must be in ascending order. ');
    }
    // Ensure the snap sizes start and end with the min and max child sizes.
    if (widget.snapSizes == null || widget.snapSizes!.isEmpty) {
      return <double>[
        widget.minChildSize,
        widget.maxChildSize,
      ];
    }
    return <double>[
      if (widget.snapSizes!.first != widget.minChildSize) widget.minChildSize,
      ...widget.snapSizes!,
      if (widget.snapSizes!.last != widget.maxChildSize) widget.maxChildSize,
    ];
  }

  void _setExtent() {
    setState(() {
      // _extent has been updated when this is called.
    });
  }

  void _replaceExtent() {
    final previousExtent = _extent;
    _extent
      ..dispose()
      ..hasDragged = false;
    _extent = _extent.copyWith(
      minSize: widget.minChildSize,
      maxSize: widget.maxChildSize,
      snap: widget.snap,
      snapSizes: _impliedSnapSizes(),
      initialSize: widget.initialChildSize,
      onSizeChanged: _setExtent,
    );

    _scrollController.extent = _extent;

    widget.controller?._onExtentReplaced(previousExtent);
    if (widget.snap) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.position.goBallistic(0);
      });
    }
  }

  String _snapSizeErrorMessage(int invalidIndex) {
    final snapSizesWithIndicator = widget.snapSizes!.asMap().keys.map(
      (index) {
        final snapSizeString = widget.snapSizes![index].toString();
        if (index == invalidIndex) {
          return '>>> $snapSizeString <<<';
        }
        return snapSizeString;
      },
    ).toList();
    return "Invalid snapSize '${widget.snapSizes![invalidIndex]}' at index $invalidIndex of:\n"
        '  $snapSizesWithIndicator';
  }
}

class _OtherDraggableScrollableSheetScrollController extends ScrollController {
  _DraggableSheetExtent extent;

  @override
  _DraggableScrollableSheetScrollPosition get position =>
      super.position as _DraggableScrollableSheetScrollPosition;

  _OtherDraggableScrollableSheetScrollController({
    required this.extent,
    double initialScrollOffset = 0.0,
    String? debugLabel,
  }) : super(
          debugLabel: debugLabel,
          initialScrollOffset: initialScrollOffset,
        );

  @override
  _DraggableScrollableSheetScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _DraggableScrollableSheetScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      getExtent: () => extent,
    );
  }

  @override
  void debugFillDescription(List<String> description) {
    super.debugFillDescription(description);
    description.add('extent: $extent');
  }

  void reset() {
    extent._cancelActivity?.call();
    extent.hasDragged = false;
    // jumpTo can result in trying to replace semantics during build.
    // Just animate really fast.
    // Avoid doing it at all if the offset is already 0.0.
    if (offset != 0.0) {
      animateTo(
        0.0,
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      );
    }
    extent.updateSize(
      extent.initialSize,
      position.context.notificationContext!,
    );
  }
}

class _DraggableScrollableSheetScrollPosition
    extends ScrollPositionWithSingleContext {
  final _DraggableSheetExtent Function() getExtent;

  bool get listShouldScroll => pixels > 0.0;

  _DraggableSheetExtent get extent => getExtent();

  VoidCallback? _dragCancelCallback;
  VoidCallback? _ballisticCancelCallback;

  bool get _isAtSnapSize {
    return extent.snapSizes.any(
      (snapSize) {
        return (extent.currentSize - snapSize).abs() <=
            extent.pixelsToSize(physics.tolerance.distance);
      },
    );
  }

  bool get _shouldSnap => extent.snap && extent.hasDragged && !_isAtSnapSize;

  _DraggableScrollableSheetScrollPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    required this.getExtent,
    double initialPixels = 0.0,
    bool keepScrollOffset = true,
    ScrollPosition? oldPosition,
    String? debugLabel,
  }) : super(
          physics: physics,
          context: context,
          initialPixels: initialPixels,
          keepScrollOffset: keepScrollOffset,
          oldPosition: oldPosition,
          debugLabel: debugLabel,
        );

  @override
  void beginActivity(ScrollActivity? newActivity) {
    _ballisticCancelCallback?.call();
    super.beginActivity(newActivity);
  }

  @override
  bool applyContentDimensions(double minScrollSize, double maxScrollSize) {
    return super.applyContentDimensions(
      minScrollSize - extent.additionalMinSize,
      maxScrollSize + extent.additionalMaxSize,
    );
  }

  @override
  void applyUserOffset(double delta) {
    if (!listShouldScroll &&
        (!(extent.isAtMin || extent.isAtMax) ||
            (extent.isAtMin && delta < 0) ||
            (extent.isAtMax && delta > 0))) {
      extent.addPixelDelta(-delta, context.notificationContext!);
    } else {
      super.applyUserOffset(delta);
    }
  }

  @override
  void dispose() {
    _ballisticCancelCallback?.call();
    super.dispose();
  }

  @override
  void goBallistic(double velocity) {
    if ((velocity == 0.0 && !_shouldSnap) ||
        (velocity < 0.0 && listShouldScroll) ||
        (velocity > 0.0 && extent.isAtMax)) {
      super.goBallistic(velocity);
      return;
    }
    _dragCancelCallback?.call();
    _dragCancelCallback = null;

    late final Simulation simulation;
    if (extent.snap) {
      simulation = _SnappingSimulation(
        position: extent.currentPixels,
        initialVelocity: velocity,
        pixelSnapSize: extent.pixelSnapSizes,
        tolerance: physics.tolerance,
      );
    } else {
      simulation = ClampingScrollSimulation(
        position: extent.currentPixels,
        velocity: velocity,
        tolerance: physics.tolerance,
      );
    }

    final ballisticController = AnimationController.unbounded(
      debugLabel: objectRuntimeType(this, '_DraggableScrollableSheetPosition'),
      vsync: context.vsync,
    );

    _ballisticCancelCallback = ballisticController.stop;
    var lastPosition = extent.currentPixels;
    // ignore: no_leading_underscores_for_local_identifiers
    void _tick() {
      final delta = ballisticController.value - lastPosition;
      lastPosition = ballisticController.value;
      extent.addPixelDelta(delta, context.notificationContext!);
      if ((velocity > 0 && extent.isAtMax) ||
          (velocity < 0 && extent.isAtMin)) {
        // ignore: parameter_assignments
        velocity = ballisticController.velocity +
            (physics.tolerance.velocity * ballisticController.velocity.sign);
        super.goBallistic(velocity);
        ballisticController.stop();
      } else if (ballisticController.isCompleted) {
        super.goBallistic(0);
      }
    }

    ballisticController
      ..addListener(_tick)
      ..animateWith(simulation).whenCompleteOrCancel(
        () {
          _ballisticCancelCallback = null;
          ballisticController.dispose();
        },
      );
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    _dragCancelCallback = dragCancelCallback;
    return super.drag(details, dragCancelCallback);
  }
}

/// descendants that they should reset to initial state.
class _ResetNotifier extends ChangeNotifier {
  /// Whether someone called [sendReset] or not.
  ///
  /// This flag should be reset after checking it.
  bool _wasCalled = false;

  /// Fires a reset notification to descendants.
  ///
  /// Returns false if there are no listeners.
  bool sendReset() {
    if (!hasListeners) {
      return false;
    }
    _wasCalled = true;
    notifyListeners();
    return true;
  }
}

class _InheritedResetNotifier extends InheritedNotifier<_ResetNotifier> {
  /// Creates an [InheritedNotifier] that the [OtherDraggableScrollableSheet] will
  /// listen to for an indication that it should reset itself back to [OtherDraggableScrollableSheet.initialChildSize].
  ///
  /// The [child] and [notifier] properties must not be null.
  const _InheritedResetNotifier({
    required Widget child,
    required _ResetNotifier notifier,
    Key? key,
  }) : super(key: key, child: child, notifier: notifier);

  // ignore: unused_element
  bool _sendReset() => notifier!.sendReset();

  /// Specifies whether the [OtherDraggableScrollableSheet] should reset to its
  /// initial position.
  ///
  /// Returns true if the notifier requested a reset, false otherwise.
  static bool shouldReset(BuildContext context) {
    final InheritedWidget? widget =
        context.dependOnInheritedWidgetOfExactType<_InheritedResetNotifier>();
    if (widget == null) {
      return false;
    }
    assert(widget is _InheritedResetNotifier);
    final inheritedNotifier = widget as _InheritedResetNotifier;
    final wasCalled = inheritedNotifier.notifier!._wasCalled;
    inheritedNotifier.notifier!._wasCalled = false;
    return wasCalled;
  }
}

class _SnappingSimulation extends Simulation {
  _SnappingSimulation({
    required this.position,
    required double initialVelocity,
    required List<double> pixelSnapSize,
    Tolerance tolerance = Tolerance.defaultTolerance,
  }) : super(tolerance: tolerance) {
    _pixelSnapSize = _getSnapSize(initialVelocity, pixelSnapSize);
    // Check the direction of the target instead of the sign of the velocity because
    // we may snap in the opposite direction of velocity if velocity is very low.
    if (_pixelSnapSize < position) {
      velocity = math.min(-minimumSpeed, initialVelocity);
    } else {
      velocity = math.max(minimumSpeed, initialVelocity);
    }
  }

  final double position;
  late final double velocity;

  // A minimum speed to snap at. Used to ensure that the snapping animation
  // does not play too slowly.
  static const double minimumSpeed = 1600.0;

  late final double _pixelSnapSize;

  @override
  double dx(double time) {
    if (isDone(time)) {
      return 0;
    }
    return velocity;
  }

  @override
  bool isDone(double time) {
    return x(time) == _pixelSnapSize;
  }

  @override
  double x(double time) {
    final newPosition = position + velocity * time;
    if ((velocity >= 0 && newPosition > _pixelSnapSize) ||
        (velocity < 0 && newPosition < _pixelSnapSize)) {
      // We're passed the snap size, return it instead.
      return _pixelSnapSize;
    }
    return newPosition;
  }

  double _getSnapSize(double initialVelocity, List<double> pixelSnapSizes) {
    final indexOfNextSize =
        pixelSnapSizes.indexWhere((size) => size >= position);
    if (indexOfNextSize == 0) {
      return pixelSnapSizes.first;
    }
    final nextSize = pixelSnapSizes[indexOfNextSize];
    final previousSize = pixelSnapSizes[indexOfNextSize - 1];
    if (initialVelocity.abs() <= tolerance.velocity) {
      // If velocity is zero, snap to the nearest snap size with the minimum velocity.
      if (position - previousSize < nextSize - position) {
        return previousSize;
      } else {
        return nextSize;
      }
    }
    // Snap forward or backward depending on current velocity.
    if (initialVelocity < 0.0) {
      return pixelSnapSizes[indexOfNextSize - 1];
    }
    return pixelSnapSizes[indexOfNextSize];
  }
}
