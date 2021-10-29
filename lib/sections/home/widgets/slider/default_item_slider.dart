import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:bausch/sections/home/widgets/slider/indicator.dart';
import 'package:bausch/sections/home/widgets/slider/item_row.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomItemSlider extends StatefulWidget {
  final List<CatalogItemModel> items;
  final Duration animationDuration;
  final int itemsOnPage;
  final int indicatorsOnPage;
  final double spaceBetween;

  const CustomItemSlider({
    required this.items,
    this.itemsOnPage = 2,
    this.indicatorsOnPage = 3,
    this.spaceBetween = 4,
    this.animationDuration = const Duration(milliseconds: 300),
    Key? key,
  }) : super(key: key);

  @override
  _CustomItemSliderState createState() => _CustomItemSliderState();
}

class _CustomItemSliderState extends State<CustomItemSlider> {
  final sliderCubit = SliderCubit();

  late List<CatalogItemModel> scrollItems;
  int direction = 0;
  int page = 2;

  @override
  void initState() {
    super.initState();
    scrollItems = [
      ...widget.items.skip(widget.items.length - 4),
      ...widget.items,
      ...widget.items.take(4),
    ];
    debugPrint('scrollItems.length: ${scrollItems.length}');
  }

  @override
  void dispose() {
    sliderCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sliderCubit,
      child: Column(
        children: [
          ItemRow(
            animationDuration: widget.animationDuration,
            itemsOnPage: widget.itemsOnPage,
            spaceBetween: widget.spaceBetween,
            items: scrollItems,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 120.0),
            child: OtherIndicatorRow(),
          ),
        ],
      ),
    );
  }
}

class OtherIndicatorRow extends StatefulWidget {
  final double spaceBetween;
  final int indexesOnPage;

  const OtherIndicatorRow({
    this.spaceBetween = 4,
    this.indexesOnPage = 3,
    Key? key,
  }) : super(key: key);

  @override
  State<OtherIndicatorRow> createState() => _OtherIndicatorRowState();
}

class _OtherIndicatorRowState extends State<OtherIndicatorRow> {
  final controller = ScrollController();

  int currentGlobalIndex = 1;
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
            widget.indexesOnPage;

        return BlocConsumer<SliderCubit, SliderState>(
          listener: (context, state) {
            if (state is SliderSlideTo && state.direction != 0) {
              currentGlobalIndex += state.direction;
              debugPrint('$currentGlobalIndex');

              slideIndex();
            }
          },
          builder: (context, state) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scroll) {
                if (scroll is ScrollEndNotification) {
                  onEnd(scroll);
                }
                return false;
              },
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      5 + 3,
                      (i) {
                        final innerIndex = (i + 1) % (5 - 1);
                        final currentInnerIndex =
                            (currentGlobalIndex + 1) % (5 - 1);

                        return Column(
                          children: [
                            Indicator(
                              ownIndex: innerIndex,
                              currentIndex: currentInnerIndex,
                              indicatorWidth: indicatorWidth,
                              rightMargin: widget.spaceBetween,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              onPressed: () {
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
      const Duration(milliseconds: 200),
      () => controller.animateTo(
        (currentGlobalIndex - 1) * (indicatorWidth + widget.spaceBetween),
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeOutQuart,
      ),
    );
  }

  void onEnd(ScrollNotification scroll) {
    if (scroll.metrics.extentBefore < indicatorWidth + widget.spaceBetween) {
      setState(
        () {
          currentGlobalIndex = 5;
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
          currentGlobalIndex = 2;
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
