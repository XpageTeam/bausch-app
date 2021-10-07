import 'dart:async';

import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';

class CustomImageSlideshow extends StatefulWidget {
  /// The widgets to display in the [CustomImageSlideshow].
  ///
  /// Mainly intended for image widget, but other widgets can also be used.
  final List<Widget> children;

  /// Width of the [CustomImageSlideshow].
  final double width;

  /// Height of the [CustomImageSlideshow].
  final double height;

  /// The page to show when first creating the [CustomImageSlideshow].
  final int initialPage;

  /// The color to paint the indicator.
  final Color? indicatorColor;

  /// The color to paint behind th indicator.
  final Color? indicatorBackgroundColor;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int>? onPageChanged;

  /// Auto scroll interval.
  ///
  /// Do not auto scroll when you enter null or 0.
  final int? autoPlayInterval;

  /// loop to return first slide.
  final bool isLoop;

  final double indicatorBottomPadding;
  const CustomImageSlideshow({
    Key? key,
    required this.children,
    this.width = double.infinity,
    this.height = 200,
    this.initialPage = 0,
    this.indicatorColor,
    this.indicatorBackgroundColor = Colors.grey,
    this.onPageChanged,
    this.autoPlayInterval,
    this.isLoop = false,
    this.indicatorBottomPadding = 15,
  }) : super(key: key);

  @override
  _CustomImageSlideshowState createState() => _CustomImageSlideshowState();
}

class _CustomImageSlideshowState extends State<CustomImageSlideshow> {
  final _currentPageNotifier = ValueNotifier(0);
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.initialPage,
    );
    _currentPageNotifier.value = widget.initialPage;

    if (widget.autoPlayInterval != null && widget.autoPlayInterval != 0) {
      _autoPlayTimerStart();
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Flexible(
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              onPageChanged: _onPageChanged,
              itemCount: widget.isLoop ? null : widget.children.length,
              controller: _pageController,
              itemBuilder: (context, index) {
                final correctIndex = index % widget.children.length;
                return widget.children[correctIndex];
              },
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          ValueListenableBuilder<int>(
            valueListenable: _currentPageNotifier,
            builder: (context, value, child) {
              return Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: List.generate(
                  widget.children.length,
                  (index) {
                    return Container(
                      height: 4,
                      width: MediaQuery.of(context).size.width /
                              widget.children.length -
                          (widget.children.length - 1) * 4 -
                          StaticData.sidePadding * 6,
                      color: value % widget.children.length == index
                          ? widget.indicatorColor
                          : widget.indicatorBackgroundColor,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    _currentPageNotifier.value = index;
    if (widget.onPageChanged != null) {
      final correctIndex = index % widget.children.length;
      widget.onPageChanged!(correctIndex);
    }
  }

  void _autoPlayTimerStart() {
    Timer.periodic(
      Duration(milliseconds: widget.autoPlayInterval!),
      (timer) {
        int nextPage;
        if (widget.isLoop) {
          nextPage = _currentPageNotifier.value + 1;
        } else {
          if (_currentPageNotifier.value < widget.children.length - 1) {
            nextPage = _currentPageNotifier.value + 1;
          } else {
            return;
          }
        }

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      },
    );
  }
}
