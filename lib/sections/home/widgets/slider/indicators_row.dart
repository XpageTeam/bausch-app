import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:bausch/sections/home/widgets/slider/indicators_scroll_controller.dart';
import 'package:bausch/sections/home/widgets/slider/no_glow_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef IndicatorBuilder = Widget Function(
  BuildContext context,
  bool isActive,
);

class IndicatorsRow extends StatefulWidget {
  final int indicatorsOnPage;
  final double spaceBetween;
  final double maxWidth;
  final Duration animationDuration;
  final IndicatorBuilder builder;

  const IndicatorsRow({
    required this.indicatorsOnPage,
    required this.spaceBetween,
    required this.maxWidth,
    required this.animationDuration,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  _IndicatorsRowState createState() => _IndicatorsRowState();
}

class _IndicatorsRowState extends State<IndicatorsRow> {
  late final scrollController = IndicatorsScrollController(
    initialScrollOffset:
        (widget.indicatorsOnPage ~/ 2) * (indicatorWidth + widget.spaceBetween),
    triggerOffset: indicatorWidth + widget.spaceBetween,
    viewportDim: indicatorWidth + widget.spaceBetween,
  );

  late final int count = widget.indicatorsOnPage * 2 + 2;
  late double indicatorWidth;

  int currentIndex = 0;
  int currentPage = 1;
  bool isIndicatorClick = false;
  bool indicatorsBlock = false;

  late SliderCubit sliderCubit;

  @override
  void initState() {
    super.initState();

    sliderCubit = BlocProvider.of<SliderCubit>(context);
    indicatorWidth = (widget.maxWidth -
            widget.spaceBetween * (widget.indicatorsOnPage - 1)) /
        widget.indicatorsOnPage;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SliderCubit, SliderState>(
      listener: (context, state) {
        if (scrollController.hasClients && state is SliderSlidePage) {
          if (isIndicatorClick) {
            isIndicatorClick = false;
          } else {
            indicatorsBlock = true;

            changePage(
              (scrollController.page + state.scrollPages - 1) % 4,
              state.scrollPages,
            );
          }
        }
      },
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              count,
              (i) {
                final innerIndex = (i - 2) % (widget.indicatorsOnPage + 1);
                return GestureDetector(
                  onTap: () {
                    if (!indicatorsBlock) {
                      indicatorsBlock = true;
                      isIndicatorClick = true;

                      var direction = 0;

                      // Влево
                      if (innerIndex < currentIndex) {
                        if (innerIndex - currentIndex >
                            -(widget.indicatorsOnPage - 1)) {
                          direction = innerIndex - currentIndex;
                        } else {
                          direction = 1;
                        }
                      }

                      // Вправо
                      if (innerIndex > currentIndex) {
                        if (innerIndex - currentIndex <
                            (widget.indicatorsOnPage - 1)) {
                          direction = innerIndex - currentIndex;
                        } else {
                          direction = -1;
                        }
                      }

                      changePage(innerIndex, direction);

                      if (direction > 0) {
                        sliderCubit.movePageBy(1);
                      }
                      if (direction < 0) {
                        sliderCubit.movePageBy(-1);
                      }
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(
                      right: i == count - 1 ? 0 : widget.spaceBetween,
                    ),
                    width: indicatorWidth,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: widget.builder(
                      context,
                      currentIndex == innerIndex,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void changePage(
    int newCurrentIndex,
    int direction,
  ) {
    setState(
      () {
        currentIndex = newCurrentIndex;
      },
    );
    if (direction > 0) {
      delayed(
        () => scrollController.nextPage().then(
              (value) => indicatorsBlock = false,
            ),
      );
    }
    if (direction < 0) {
      delayed(
        () => scrollController.previousPage().then(
              (value) => indicatorsBlock = false,
            ),
      );
    }
  }

  void delayed(VoidCallback func) {
    Future<void>.delayed(
      const Duration(
        milliseconds: 100,
      ),
      func,
    );
  }
}
