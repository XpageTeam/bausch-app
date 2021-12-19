import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:bausch/sections/home/widgets/slider/items_scroll_controller.dart';
import 'package:bausch/sections/home/widgets/slider/no_glow_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

class ItemsRow<T> extends StatefulWidget {
  final List<T> items;
  final int itemsOnPage;
  final double maxWidth;
  final double spaceBetween;

  final Duration animationDuration;

  final ItemBuilder<T> builder;

  const ItemsRow({
    required this.items,
    required this.animationDuration,
    required this.itemsOnPage,
    required this.maxWidth,
    required this.spaceBetween,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  State<ItemsRow<T>> createState() => _ItemsRowState<T>();
}

class _ItemsRowState<T> extends State<ItemsRow<T>> {
  late final ItemsScrollController scrollController;
  late SliderCubit sliderCubit;
  late double currentPage;

  late int scrollLength;

  int scrolledPages = 0;

  @override
  void initState() {
    super.initState();
    sliderCubit = BlocProvider.of<SliderCubit>(context);

    currentPage = 1;
    scrollLength = widget.items.length + widget.itemsOnPage * 2;

    scrollController = ItemsScrollController(
      initialPage: 1,
      // viewportFraction = (maxWidth + spaceBetween) / maxWidth
      viewportFraction: 1 + widget.spaceBetween / widget.maxWidth,
      intemsOnPage: widget.itemsOnPage,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      scrollController.addListener(() {
        setState(() {
          final currentPageRound = currentPage.round();
          final pageRound = scrollController.page!.round();
          if (currentPageRound != pageRound) {
            currentPage = scrollController.page!;
            scrolledPages++;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SliderCubit, SliderState>(
      listener: (context, state) {
        if (scrollController.hasClients && state is SliderMovePage) {
          if (state.scrollPages > 0) {
            scrollController.nextPageDouble(
              duration: widget.animationDuration,
              curve: Curves.easeOutQuart,
            );
          }
          if (state.scrollPages < 0) {
            scrollController.previousPageDouble(
              duration: widget.animationDuration,
              curve: Curves.easeOutQuart,
            );
          }
        }
      },
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll is ScrollEndNotification) {
              if (scrolledPages > 0) {
                final dir = scrollController.direction;
                if (dir > 0) {
                  sliderCubit.slidePageBy(1);
                }
                if (dir < 0) {
                  sliderCubit.slidePageBy(-1);
                }
              }
              scrolledPages = 0;
            }

            return false;
          },
          child: Column(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: IntrinsicHeight(
                  child: Row(
                    children: List.generate(
                      scrollLength,
                      (i) {
                        final index =
                            (i - widget.itemsOnPage) % widget.items.length;
                        return Container(
                          margin: EdgeInsets.only(
                            right:
                                i == scrollLength - 1 ? 0 : widget.spaceBetween,
                          ),
                          width: (widget.maxWidth -
                                  (widget.itemsOnPage - 1) *
                                      widget.spaceBetween) /
                              widget.itemsOnPage,
                          child: widget.builder(
                            context,
                            widget.items[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
