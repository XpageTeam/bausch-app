import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:bausch/sections/home/widgets/slider/indicator.dart';
import 'package:bausch/sections/home/widgets/slider/item_row.dart';
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
          LayoutBuilder(
            builder: (context, constraints) {
              return ItemRow(
                maxWidth: constraints.maxWidth,
                animationDuration: widget.animationDuration,
                itemsOnPage: widget.itemsOnPage,
                spaceBetween: widget.spaceBetween,
                items: scrollItems,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return BlocBuilder<SliderCubit, SliderState>(
                  builder: (context, state) {
                    return OtherIndicatorRow(
                      direction: state is SliderSlideTo ? state.direction : 0,
                      maxWidth: constraints.maxWidth,
                    );
                    // return OtherIndicatorRow(page: state.page);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OtherIndicatorRow extends StatefulWidget {
  final double indicatorWidth;
  final double maxWidth;
  final double spaceBetween;
  final int indexesOnPage;
  final int direction;

  const OtherIndicatorRow({
    required this.maxWidth,
    required this.direction,
    this.spaceBetween = 4,
    this.indexesOnPage = 3,
    Key? key,
  })  : indicatorWidth = (maxWidth - spaceBetween * 2) / indexesOnPage,
        super(key: key);

  @override
  State<OtherIndicatorRow> createState() => _OtherIndicatorRowState();
}

class _OtherIndicatorRowState extends State<OtherIndicatorRow> {
  late final ScrollController controller;
  late int currentIndex = (widget.indexesOnPage + 2) ~/ 2;

  @override
  void initState() {
    super.initState();
    controller = ScrollController(
      initialScrollOffset: widget.indicatorWidth + widget.spaceBetween,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.direction < 0) {
      controller.animateTo(
        (widget.indicatorWidth + widget.spaceBetween) * (currentIndex - 2),
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
    if (widget.direction > 0) {
      controller.animateTo(
        (widget.indicatorWidth + widget.spaceBetween) * currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        if (scroll is ScrollEndNotification) {
          onEnd(scroll);
        }
        return false;
      },
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            widget.indexesOnPage + 2,
            (i) => Indicator(
              ownIndex: i,
              currentIndex: currentIndex,
              indicatorWidth: widget.indicatorWidth,
              rightMargin: widget.spaceBetween,
              animationDuration: const Duration(milliseconds: 300),
              onPressed: () {
                if (currentIndex > i) {
                  BlocProvider.of<SliderCubit>(context).movePageTo(-1);
                }
                if (currentIndex < i) {
                  BlocProvider.of<SliderCubit>(context).movePageTo(1);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void onEnd(ScrollNotification scroll) {
    if (scroll.metrics.extentBefore <
            widget.indicatorWidth + widget.spaceBetween ||
        scroll.metrics.extentAfter <
            widget.indicatorWidth + widget.spaceBetween) {
      Future.delayed(
        Duration.zero,
        () => controller.jumpTo(
          widget.indicatorWidth + widget.spaceBetween,
        ),
      );
    }
  }
}
