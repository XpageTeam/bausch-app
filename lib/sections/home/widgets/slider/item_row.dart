import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/home/widgets/default_catalog_item.dart';
import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemRow extends StatefulWidget {
  final List<CatalogItemModel> items;
  final int itemsOnPage;
  final double spaceBetween;
  final Duration animationDuration;

  const ItemRow({
    required this.items,
    required this.animationDuration,
    this.itemsOnPage = 2,
    this.spaceBetween = 4,
    Key? key,
  }) : super(key: key);

  @override
  State<ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> with TickerProviderStateMixin {
  late final ScrollController controller = ScrollController(
    initialScrollOffset: (maxWidth + 4) * 2,
  );

// TODO(Nikolay): ! Проблема !.
  // late final SliderCubit sliderCubit;
  int currentPage = 2;
  late double maxWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // sliderCubit = BlocProvider.of<SliderCubit>(context);

    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        controller.addListener(
          () {
            final newPage = double.parse(
              (controller.offset / maxWidth).toStringAsFixed(5),
            ).round();

            if (currentPage > newPage && currentPage - newPage < 3) {
              BlocProvider.of<SliderCubit>(context).slidePageTo(-1);
            }
            if (currentPage < newPage && currentPage - newPage > -3) {
              BlocProvider.of<SliderCubit>(context).slidePageTo(1);
            }

            setState(
              () {
                currentPage = newPage;
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        maxWidth = constraints.maxWidth;
        return BlocConsumer<SliderCubit, SliderState>(
          listener: (context, state) {
            if (controller.hasClients && state is SliderMoveTo) {
              controller.animateTo(
                maxWidth * (currentPage + state.direction) >
                        controller.position.maxScrollExtent
                    ? controller.position.maxScrollExtent
                    : (maxWidth + widget.spaceBetween) *
                        (currentPage + state.direction),
                duration: widget.animationDuration,
                curve: Curves.easeOutQuart,
              );
            }
          },
          builder: (context, state) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  onEndScroll(scrollNotification.metrics);
                }

                return true;
              },
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  // physics: physics,
                  child: IntrinsicHeight(
                    child: Row(
                      children: List.generate(
                        widget.items.length,
                        (i) => DefaultCatalogItem(
                          model: widget.items[i],
                          rightMargin: i == widget.items.length - 1
                              ? 0
                              : widget.spaceBetween,
                          itemWidth: (maxWidth - widget.spaceBetween) /
                              widget.itemsOnPage,
                        ),
                      ),
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

  void onEndScroll(ScrollMetrics metrics) {
    if (metrics.extentBefore < metrics.extentInside + widget.spaceBetween) {
      final end = metrics.maxScrollExtent -
          metrics.extentInside * 2 -
          widget.spaceBetween * 3 +
          (metrics.pixels - metrics.extentInside);

      jumpTo(end);
    }
    if (metrics.extentAfter < metrics.extentInside + widget.spaceBetween) {
      final start = metrics.extentInside * 2 +
          widget.spaceBetween * 3 +
          metrics.extentInside +
          metrics.pixels -
          metrics.maxScrollExtent;

      jumpTo(start);
    }
  }

  Future<void> jumpTo(double offset) async {
    await Future.delayed(
      Duration.zero,
      () => controller.jumpTo(offset),
    );
  }

  Future<void> animateTo(double offset) async {
    await Future.delayed(
      Duration.zero,
      () => controller.animateTo(
        offset,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.linear,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

class ConstrainedItemRow extends StatelessWidget {
  final Duration animationDuration;
  final int itemsOnPage;
  final double spaceBetween;
  final List<CatalogItemModel> items;
  const ConstrainedItemRow({
    required this.animationDuration,
    required this.itemsOnPage,
    required this.spaceBetween,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ItemRow(
          // maxWidth: constraints.maxWidth,
          animationDuration: animationDuration,
          itemsOnPage: itemsOnPage,
          spaceBetween: spaceBetween,
          items: items,
        );
      },
    );
  }
}
