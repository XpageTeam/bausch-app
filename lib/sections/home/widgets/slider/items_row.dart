import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:bausch/sections/home/widgets/slider/custom_scroll_controller.dart';
import 'package:bausch/sections/home/widgets/slider/item_slider.dart';
import 'package:bausch/sections/home/widgets/slider/no_glow_behavior.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

class ItemsRow<T> extends StatefulWidget {
  final List<T> items;
  final AbstractSliderController sliderController;
  final int itemsOnPage;
  final double maxWidth;
  final double spaceBetween;

  final Duration animationDuration;

  final ItemBuilder<T> builder;

  const ItemsRow({
    required this.items,
    required this.sliderController,
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
  late final double triggerOffset;
  // late final ScrollController controller;
  late CustomScrollController scrollController;
  late int currentPage;
  late double itemWidth;
  late double stepWidth;
  late int scrollLength;

  int scrolledPages = 0;
  int counter = 0;

  @override
  void initState() {
    super.initState();

    currentPage = 1;
    itemWidth =
        (widget.maxWidth - (widget.itemsOnPage - 1) * widget.spaceBetween) /
            widget.itemsOnPage;

    stepWidth = itemWidth + widget.spaceBetween;
    scrollLength = widget.items.length + widget.itemsOnPage * 2;
    triggerOffset = widget.maxWidth + widget.spaceBetween;

    scrollController = CustomScrollController(
      triggerOffset: triggerOffset,
      initialScrollOffset: currentPage * stepWidth,
      pagesCount: scrollLength ~/ widget.itemsOnPage,
      viewportDim: stepWidth,
    );
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
            scrollController.nextPage();
          }
          if (state.scrollPages < 0) {
            scrollController.previousPage();
          }
        }
      },
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll is ScrollEndNotification) {
              // TODO(Nikolay): Из-за того, что скроллер зациклен, то появляется баг,
              // когда сильно проскроллил, например влево, и текущая страница стала, к примеру,
              // на один больше и индикоторам отправляется неверное событие
              // (в этом случае должно отправляться событие влево, а отправится вправо)
              
              if (scrollController.distance > 0) {
                final dir = scrollController.direction;
                if (dir == ScrollDirection.reverse) {
                  widget.sliderController.slideNext();
                }
                if (dir == ScrollDirection.forward) {
                  widget.sliderController.slidePrev();
                }
              }

              scrolledPages = 0;
            }

            return false;
          },
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(
                children: List.generate(
                  scrollLength,
                  (i) {
                    final index =
                        (i - widget.itemsOnPage) % widget.items.length;
                    return Container(
                      margin: EdgeInsets.only(
                        right: i == scrollLength - 1 ? 0 : widget.spaceBetween,
                      ),
                      width: itemWidth,
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
        ),
      ),
    );
  }
}

// typedef ItemBuilder<T> = Widget Function(
//   BuildContext context,
//   T item,
// );

// class ItemsRow<T> extends StatefulWidget {
//   final List<T> items;
//   final int itemsOnPage;
//   final double maxWidth;
//   final double spaceBetween;
//   final int initPage;
//   final Duration animationDuration;

//   final ItemBuilder<T> builder;

//   const ItemsRow({
//     required this.items,
//     required this.animationDuration,
//     required this.itemsOnPage,
//     required this.maxWidth,
//     required this.initPage,
//     required this.spaceBetween,
//     required this.builder,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<ItemsRow<T>> createState() => _ItemsRowState<T>();
// }

// class _ItemsRowState<T> extends State<ItemsRow<T>> {
//   late final double triggerOffset = widget.maxWidth + widget.spaceBetween;
//   late final controller = widget.items.length / widget.itemsOnPage <= 3
//       ? ScrollController()
//       : CustomScrollController(
//           triggerOffset: triggerOffset,
//           initialScrollOffset:
//               currentPage * (widget.maxWidth + widget.spaceBetween),
//         );

//   late int currentPage = 1;
//   late double itemWidth;
//   int scrolledPages = 0;

//   int counter = 0;

//   @override
//   void initState() {
//     super.initState();

//     itemWidth =
//         (widget.maxWidth - (widget.itemsOnPage - 1) * widget.spaceBetween) /
//             widget.itemsOnPage;
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     WidgetsBinding.instance?.addPostFrameCallback(
//       (_) {
//         controller.addListener(
//           () {
//             final otherNewPage = double.parse(
//               (controller.offset / (widget.maxWidth + widget.spaceBetween))
//                   .toStringAsFixed(5),
//             ).round();

//             if (currentPage != otherNewPage) {
//               // TODO(Nikolay): Изменить.
//               // if (otherNewPage < currentPage) {
//               //   if (otherNewPage - currentPage > -3) {
//               //     scrolledPages -= 1;
//               //   } else {
//               //     scrolledPages += 1;
//               //   }
//               // }

//               // // Вправо
//               // if (otherNewPage > currentPage) {
//               //   if (otherNewPage - currentPage < 3) {
//               //     scrolledPages += 1;
//               //   } else {
//               //     scrolledPages -= 1;
//               //   }
//               // }
//               var scrollPages = 0;

//               // TODO(Nikolay): Протестить.
//               if (otherNewPage < currentPage &&
//                       otherNewPage - currentPage >= -1 ||
//                   otherNewPage > currentPage &&
//                       otherNewPage - currentPage > 1) {
//                 // Влево
//                 scrolledPages = -1;
//               } else {
//                 // Вправо
//                 scrolledPages = 1;
//               }
//               setState(
//                 () {
//                   currentPage = otherNewPage;
//                 },
//               );
//             }
//           },
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<SliderCubit, SliderState>(
//       listener: (context, state) {
//         if (controller.hasClients && state is SliderMovePage) {
//           final newOffset =
//               currentPage * (widget.maxWidth + widget.spaceBetween) +
//                   state.scrollPages * (widget.maxWidth + widget.spaceBetween);

//           controller.animateTo(
//             newOffset,
//             duration: widget.animationDuration,
//             curve: Curves.easeOutQuart,
//           );
//         }
//       },
//       child: ScrollConfiguration(
//         behavior: NoGlowScrollBehavior(),
//         child: NotificationListener<ScrollNotification>(
//           onNotification: (scroll) {
//             if (scroll is ScrollEndNotification) {
//               if (scrolledPages != 0) {
//                 BlocProvider.of<SliderCubit>(context)
//                     // TODO(Nikolay): Переделать на "неограниченное" количество страниц при скроллинге.
//                     .slidePageBy(scrolledPages.sign);
//                 scrolledPages = 0;
//               }
//             }

//             return false;
//           },
//           child: SingleChildScrollView(
//             controller: controller,
//             physics: const AlwaysScrollableScrollPhysics(),
//             scrollDirection: Axis.horizontal,
//             child: IntrinsicHeight(
//               child: Row(
//                 children: List.generate(
//                   widget.items.length,
//                   (index) => Container(
//                     margin: EdgeInsets.only(
//                       right: index == widget.items.length - 1
//                           ? 0
//                           : widget.spaceBetween,
//                     ),
//                     width: itemWidth,
//                     child: widget.builder(
//                       context,
//                       widget.items[index],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
