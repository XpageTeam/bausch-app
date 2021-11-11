import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:bausch/sections/home/widgets/slider/indicator.dart';
import 'package:bausch/sections/home/widgets/slider/no_glow_behavior.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndicatorsRow extends StatefulWidget {
  final double spaceBetween;
  final int indicatorsOnPage;
  final Duration animationDuration;

  const IndicatorsRow({
    this.spaceBetween = 4,
    this.indicatorsOnPage = 3,
    this.animationDuration = const Duration(
      milliseconds: 300,
    ),
    Key? key,
  }) : super(key: key);

  @override
  State<IndicatorsRow> createState() => _IndicatorsRowState();
}

class _IndicatorsRowState extends State<IndicatorsRow> {
  late final controller = ScrollController(
    initialScrollOffset:
        (widget.indicatorsOnPage ~/ 2) * (indicatorWidth + widget.spaceBetween),
  );

  // int currentGlobalIndex = 2;
  late int currentGlobalIndex = widget.indicatorsOnPage - 1;
  late double indicatorWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        indicatorWidth = (constraints.maxWidth - widget.spaceBetween * 2) /
            widget.indicatorsOnPage;

        return BlocConsumer<SliderCubit, SliderState>(
          listener: (context, state) {
            if (state is SliderSlideTo && state.direction != 0) {
              currentGlobalIndex += state.direction;

              slideIndex();
            }
          },
          builder: (context, state) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scroll) {
                if (scroll is ScrollEndNotification) {
                  onEndScroll(scroll);
                }
                return false;
              },
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      // widget.indexesOnPage + 2 + 1,
                      // (i) {
                      //   final innerIndex = (i + 1) % (widget.indexesOnPage);
                      //   final currentInnerIndex =
                      //       (currentGlobalIndex + 1) % (widget.indexesOnPage);

                      /// _ _ - _ _ _ - _
                      /// _ _ _ _ - _ _ _ _ _ - _
                      ///

                      // 5 + 3,
                      // (i) {
                      //   final innerIndex = (i + 1) % (5 - 1);
                      //   final currentInnerIndex =
                      //       (currentGlobalIndex + 1) % (5 - 1);

                      // 8 - 3
                      // 12 - 5
                      widget.indicatorsOnPage * 2 + 2,
                      (i) {
                        final innerIndex =
                            (i + 1) % (widget.indicatorsOnPage + 1);
                        final currentInnerIndex = (currentGlobalIndex + 1) %
                            (widget.indicatorsOnPage + 1);

                        return Column(
                          children: [
                            Indicator(
                              ownIndex: innerIndex,
                              currentIndex: currentInnerIndex,
                              indicatorWidth: indicatorWidth,
                              rightMargin: widget.spaceBetween,
                              animationDuration: widget.animationDuration,
                              onPressed: () {
                                debugPrint(
                                  'currentInnerIndex - innerIndex: ${currentInnerIndex - innerIndex}',
                                );
                                if (currentInnerIndex > innerIndex) {
                                  if (currentInnerIndex - innerIndex > 1) {
                                    BlocProvider.of<SliderCubit>(context)
                                        .movePageTo(1);
                                  } else {
                                    BlocProvider.of<SliderCubit>(context)
                                        .movePageTo(-1);
                                  }
                                }
                                if (currentInnerIndex < innerIndex) {
                                  if (currentInnerIndex - innerIndex < -1) {
                                    BlocProvider.of<SliderCubit>(context)
                                        .movePageTo(-1);
                                  } else {
                                    BlocProvider.of<SliderCubit>(context)
                                        .movePageTo(1);
                                  }
                                }
                              },
                            ),
                            Text(
                              '$innerIndex',
                              style: AppStyles.h2.copyWith(
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              '$i',
                              style: AppStyles.h2.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void slideIndex() {
    Future.delayed(
      widget.animationDuration * 2 ~/ 3,
      () => controller.animateTo(
        (currentGlobalIndex - 1) * (indicatorWidth + widget.spaceBetween),
        duration: widget.animationDuration * 2 ~/ 3,
        curve: Curves.easeOutQuart,
      ),
    );
  }

  void onEndScroll(ScrollNotification scroll) {
    // TODO(Nikolay): При увеличении количества индикаторов на странице начинает неправильно считать.
    if (scroll.metrics.extentBefore < indicatorWidth + widget.spaceBetween) {
      setState(
        () {
          currentGlobalIndex = widget.indicatorsOnPage * 2 - 1; // 5;
        },
      );
      jumpTo(
        scroll.metrics.maxScrollExtent -
            (indicatorWidth + widget.spaceBetween * 2),
      );
    }
    if (scroll.metrics.extentAfter < indicatorWidth + widget.spaceBetween) {
      setState(
        () {
          currentGlobalIndex = widget.indicatorsOnPage - 1; // 2;
        },
      );
      jumpTo(indicatorWidth + widget.spaceBetween);
    }
  }

  void jumpTo(double offset) {
    Future.delayed(
      Duration.zero,
      () => controller.jumpTo(
        offset,
      ),
    );
  }
}
