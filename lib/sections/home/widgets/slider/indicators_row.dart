import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:bausch/sections/home/widgets/slider/custom_scroll_controller.dart';
import 'package:bausch/sections/home/widgets/slider/item_slider.dart';
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
  final AbstractSliderController sliderController;

  const IndicatorsRow({
    required this.indicatorsOnPage,
    required this.spaceBetween,
    required this.maxWidth,
    required this.animationDuration,
    required this.builder,
    required this.sliderController,
    Key? key,
  }) : super(key: key);

  @override
  _IndicatorsRowState createState() => _IndicatorsRowState();
}

class _IndicatorsRowState extends State<IndicatorsRow> {
  late final scrollController = CustomScrollController(
    initialScrollOffset:
        (widget.indicatorsOnPage ~/ 2) * (indicatorWidth + widget.spaceBetween),
    triggerOffset: indicatorWidth + widget.spaceBetween,
    pagesCount: count - 2,
    viewportDim: indicatorWidth + widget.spaceBetween,
  );

  late final int count = widget.indicatorsOnPage * 2 + 2;
  late double indicatorWidth;

  int currentIndex = 0;
  int currentPage = 1;
  bool isIndicatorClick = false;
  bool indicatorsBlock = false;

  @override
  void initState() {
    super.initState();

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
                return Column(
                  children: [
                    GestureDetector(
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
                              // TODO(Nikolay): Изменить.
                              direction = 1;
                            }
                          }

                          // Вправо
                          if (innerIndex > currentIndex) {
                            if (innerIndex - currentIndex <
                                (widget.indicatorsOnPage - 1)) {
                              direction = innerIndex - currentIndex;
                            } else {
                              // TODO(Nikolay): Изменить.
                              direction = -1;
                            }
                          }

                          changePage(innerIndex, direction);

                          if (direction > 0) {
                            widget.sliderController.clickNext();
                          }
                          if (direction < 0) {
                            widget.sliderController.clickPrev();
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
                    ),
                    Text(
                      '$innerIndex',
                    ),
                    Text(
                      '$i',
                    ),
                  ],
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

  // void animateTo(int scrollPages) {
  //   final newOffset =
  //       (currentPage + scrollPages) * (indicatorWidth + widget.spaceBetween);

  //   Future.delayed(
  //     widget.animationDuration ~/ 2,
  //     () => controller.animateTo(
  //       newOffset,
  //       duration: widget.animationDuration ~/ 2,
  //       curve: Curves.easeOutQuart,
  //     ),
  //   ).then(
  //     (value) => indicatorsBlock = false,
  //   );
  // }
}





// class IndicatorsRow extends StatefulWidget {
//   final double spaceBetween;
//   final int indicatorsOnPage;
//   final double maxWidth;

//   final Widget Function(
//     BuildContext context,
//     int ownIndex,
//     int currentIndex,
//   ) builder;

//   const IndicatorsRow({
//     required this.spaceBetween,
//     required this.indicatorsOnPage,
//     required this.maxWidth,
//     required this.builder,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _IndicatorsRowState createState() => _IndicatorsRowState();
// }

// class _IndicatorsRowState extends State<IndicatorsRow> {
//   // late final controller = CustomScrollController(
//   //   initialScrollOffset: initialOffset,
//   //   triggerOffset: indicatorWidth + 4,
//   // );

//   late final controller = ScrollController(
//       // initialScrollOffset: initialOffset,
//       );

//   late final int count = 10 + 2;
//   // late final int count = widget.indicatorsOnPage * 2 + 2;
//   late double indicatorWidth;

//   late double initialOffset = currentIndex * indicatorWidth;
//   // (indicatorWidth + widget.spaceBetween) * (widget.indicatorsOnPage ~/ 2);
//   late double newOffset = initialOffset;

//   late int currentIndex = widget.indicatorsOnPage ~/ 2;
//   late int currentPage = 1;
//   // (currentGlobalIndex + 3) % (widget.indicatorsOnPage + 1);

//   @override
//   void initState() {
//     super.initState();

//     indicatorWidth = (widget.maxWidth -
//             widget.spaceBetween * (widget.indicatorsOnPage - 1)) /
//         widget.indicatorsOnPage;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<SliderCubit, SliderState>(
//       listener: (context, state) {
//         if (state is SliderSlidePage) {
//           setState(
//             () {
//               currentIndex = (currentIndex + state.scrollPages) %
//                   (widget.indicatorsOnPage + 3);
//               currentPage = (currentPage + state.scrollPages) %
//                   (widget.indicatorsOnPage + 3);
//             },
//           );

//           //  + state.scrollPages * (indicatorWidth + widget.spaceBetween);

//           // Future.delayed(
//           //   const Duration(
//           //     milliseconds: 150,
//           //   ),
//           //   () => controller.animateTo(
//           //     newOffset,
//           //     duration: const Duration(milliseconds: 150),
//           //     curve: Curves.easeOutQuart,
//           //   ),
//           // );
//         }
//       },
//       builder: (context, state) {
//         return Column(
//           children: [
//             Text(
//               'currentPage: $currentPage',
//             ),
//             Text(
//               'currentIndex: $currentIndex',
//             ),
//             ScrollConfiguration(
//               behavior: NoGlowScrollBehavior(),
//               child: SingleChildScrollView(
//                 // physics: const NeverScrollableScrollPhysics(),
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 controller: controller,
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: List.generate(
//                     // 8 - 3
//                     // 12 - 5
//                     /// _ _ - _ _  _ - _
//                     /// _ _ _ _ - _ _ _ _ _ - _
//                     /// и т.д.

//                     count,
//                     (i) {
//                       final innerIndex = i % (widget.indicatorsOnPage + 3);
//                       return Column(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               var scrollPages = innerIndex - currentIndex;

//                               // Влево
//                               if (innerIndex < currentIndex) {
//                                 if (innerIndex - currentIndex >
//                                     -(widget.indicatorsOnPage - 1)) {
//                                   scrollPages = innerIndex - currentIndex;
//                                 } else {
//                                   // TODO(Nikolay): Изменить.
//                                   scrollPages = 1;
//                                 }
//                               }

//                               // Вправо
//                               if (innerIndex > currentIndex) {
//                                 if (innerIndex - currentIndex <
//                                     (widget.indicatorsOnPage - 1)) {
//                                   scrollPages = innerIndex - currentIndex;
//                                 } else {
//                                   // TODO(Nikolay): Изменить.
//                                   scrollPages = -1;
//                                 }
//                               }

//                               BlocProvider.of<SliderCubit>(context)
//                                   .movePageBy(scrollPages);
//                             },
//                             child: Container(
//                               color: Colors.transparent,
//                               margin: EdgeInsets.only(
//                                 right: widget.spaceBetween,
//                               ),
//                               width: indicatorWidth,
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 12.0),
//                               child: widget.builder(
//                                 context,
//                                 currentIndex,
//                                 innerIndex,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '$innerIndex',
//                           ),
//                           Text(
//                             '$i',
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// TODO(Nikolay): Ломается при быстром скроллинге.
// class IndicatorsRow extends StatefulWidget {
//   final double spaceBetween;
//   final int indicatorsOnPage;
//   final double maxWidth;

//   final Widget Function(
//     BuildContext context,
//     int ownIndex,
//     int currentIndex,
//   ) builder;

//   const IndicatorsRow({
//     required this.spaceBetween,
//     required this.indicatorsOnPage,
//     required this.maxWidth,
//     required this.builder,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _IndicatorsRowState createState() => _IndicatorsRowState();
// }

// class _IndicatorsRowState extends State<IndicatorsRow> {
//   late final controller = CustomScrollController(
//     initialScrollOffset: offset,
//     triggerOffset: indicatorWidth + 4,
//   );

//   late final int count = widget.indicatorsOnPage * 2 + 2;
//   late double indicatorWidth;

//   late double offset =
//       (indicatorWidth + widget.spaceBetween) * (widget.indicatorsOnPage ~/ 2);
//   late double newOffset = offset;

//   late int currentIndex =
//       (currentGlobalIndex + 3) % (widget.indicatorsOnPage + 1);
//   late int currentGlobalIndex = widget.indicatorsOnPage - 1;

//   @override
//   void initState() {
//     super.initState();
//     indicatorWidth = (widget.maxWidth -
//             widget.spaceBetween * (widget.indicatorsOnPage - 1)) /
//         widget.indicatorsOnPage;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<SliderCubit, SliderState>(
//       listener: (context, state) {
//         if (state is SliderSlideTo) {
//           setState(
//             () {
//               currentGlobalIndex =
//                   (currentGlobalIndex + state.scrollPages) % count;
//             },
//           );
//           newOffset = controller.offset +
//               state.scrollPages * (indicatorWidth + widget.spaceBetween);

//           Future.delayed(
//             const Duration(
//               milliseconds: 150,
//             ),
//             () => controller.animateTo(
//               newOffset,
//               duration: const Duration(milliseconds: 150),
//               curve: Curves.easeOutQuart,
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         return ScrollConfiguration(
//           behavior: NoGlowScrollBehavior(),
//           child: SingleChildScrollView(
//             physics: const NeverScrollableScrollPhysics(),
//             controller: controller,
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: List.generate(
//                 // 8 - 3
//                 // 12 - 5
//                 /// _ _ - _ _ _ - _
//                 /// _ _ _ _ - _ _ _ _ _ - _
//                 /// и т.д.
//                 ///
//                 /// но, если попробовать
//                 /// для indicatorsOnPage=3
//                 /// _ - _ _ - _
//                 /// _ _ - _ _ -
//                 /// для indicatorsOnPage=5
//                 /// _ _ - _ _ _ _ - _ _

//                 count,
//                 (i) {
//                   final innerIndex = (i + 3) % (widget.indicatorsOnPage + 1);
//                   final currentIndex =
//                       (currentGlobalIndex + 3) % (widget.indicatorsOnPage + 1);

//                   return GestureDetector(
//                     onTap: () {
//                       var scrollPages = innerIndex - currentIndex;

//                       if (innerIndex - currentIndex <
//                           -(widget.indicatorsOnPage - 1)) {
//                         scrollPages = (currentIndex - innerIndex) -
//                             (widget.indicatorsOnPage - 1);
//                       }
//                       if (innerIndex - currentIndex >
//                           (widget.indicatorsOnPage - 1)) {
//                         scrollPages = (currentIndex - innerIndex) +
//                             (widget.indicatorsOnPage - 1);
//                       }

//                       BlocProvider.of<SliderCubit>(context)
//                           .movePageBy(scrollPages);
//                     },
//                     child: Container(
//                       color: Colors.transparent,
//                       margin: EdgeInsets.only(
//                         right: widget.spaceBetween,
//                       ),
//                       width: indicatorWidth,
//                       padding: const EdgeInsets.symmetric(vertical: 12.0),
//                       child: widget.builder(
//                         context,
//                         currentIndex,
//                         innerIndex,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class IndicatorsRow extends StatefulWidget {
//   final int indicatorsCount;
//   final int indicatorsOnPage;
//   final int itemsCount;
//   final int itemsOnPage;
//   final int additionalItems;
//   const IndicatorsRow({
//     required this.itemsCount,
//     required this.itemsOnPage,
//     required this.additionalItems,
//     required this.indicatorsCount,
//     required this.indicatorsOnPage,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<IndicatorsRow> createState() => _IndicatorsRowState();
// }

// class _IndicatorsRowState extends State<IndicatorsRow> {
//   late double indicatorWidth;
//   late final initialOffset = widget.additionalItems == widget.itemsCount
//       ? 0.0
//       : (maxAvailableWidth + 4) * 1 / widget.indicatorsOnPage;
//   // late final controller = ScrollController(
//   //     // initialScrollOffset: (initIndex - 1) * (indicatorWidth + 4),
//   //     );
// TODO(Nikolay): Не работает для строки с индикаторами.
//   late final controller = CustomScrollController(
//     itemsOnPage: widget.indicatorsOnPage,
//     additionalItems: 4,
//     initialScrollOffset: initialOffset,
//   );
//   int initIndex = 2;
//   int currentIndex = 0;

//   late double maxAvailableWidth;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     debugPrint(
//       ' widget.indicatorsOnPage * 2 + 2: ${widget.indicatorsOnPage * 2 + 2}',
//     );
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         maxAvailableWidth = constraints.maxWidth;
//         indicatorWidth =
//             (maxAvailableWidth - (widget.indicatorsOnPage - 1) * 4) /
//                 widget.indicatorsOnPage;

//         return SingleChildScrollView(
//           controller: controller,
//           scrollDirection: Axis.horizontal,
//           child: BlocListener<SliderCubit, SliderState>(
//             listener: (context, state) {
//               if (state is SliderSlideTo) {
//                 setState(
//                   () {
//                     currentIndex =
//                         (currentIndex + state.scrollPages) % widget.itemsCount;
//                   },
//                 );
//               }
//             },
//             child: Row(
//               // children: List.generate(
//               //   widget.indicatorsOnPage * 2 + 2,
//               //   // widget.itemsCount,
//               //   (i) {
//               //     // final index = (i + widget.itemsCount - 1) % widget.itemsCount;
//               //     final index =
//               //         (i + 2) % (widget.itemsCount ~/ widget.itemsOnPage);

//               //     return Container(
//               //       color: AppTheme.sulu,
//               //       child: Column(
//               //         mainAxisSize: MainAxisSize.min,
//               //         children: [
//               //           Indicator(
//               //             ownIndex: index,
//               //             currentIndex: currentIndex,
//               //             indicatorWidth: indicatorWidth,
//               //             rightMargin:
//               //                 i == widget.indicatorsOnPage * 2 + 2 - 1 ? 0 : 4,
//               //             animationDuration: const Duration(
//               //               milliseconds: 300,
//               //             ),
//               //             onPressed: () {
// var scrollPages = index - currentIndex;

// TODO(Nikolay): ! Сырые формулы ! (но вроде работают).
// if (index - currentIndex <
//     -(widget.indicatorsOnPage - 1)) {
//   scrollPages = (currentIndex - index) -
//       (widget.indicatorsOnPage - 1);
// }
// if (index - currentIndex >
//     (widget.indicatorsOnPage - 1)) {
//   scrollPages = (currentIndex - index) +
//       (widget.indicatorsOnPage - 1);
// }
// debugPrint(
//   'scrollPages: $scrollPages',
// );

// setState(
//   () {
//     currentIndex = index;
//   },
// );
// // BlocProvider.of<SliderCubit>(context)
// //     .movePageTo(scrollPages);
//               //             },
//               //           ),
//               //           Text(
//               //             '$index',
//               //             style: AppStyles.h2Bold.copyWith(fontSize: 12),
//               //           ),
//               //         ],
//               //       ),
//               //     );
//               //   },
//               // ),

//               // children: List.generate(
//               //   widget.indicatorsOnPage * 2 + 2,
//               //   (i) {
//               //     final innerIndex =
//               //         (i + 2) % (widget.itemsCount ~/ widget.itemsOnPage);
//               //     return Container(
//               //       color: AppTheme.sulu,
//               //       child: Column(
//               //         mainAxisSize: MainAxisSize.min,
//               //         children: [
//               //           Indicator(
//               //             ownIndex: innerIndex,
//               //             currentIndex: currentIndex,
//               //             indicatorWidth: indicatorWidth,
//               //             rightMargin: 4,
//               //             animationDuration: const Duration(
//               //               milliseconds: 300,
//               //             ),
//               //             onPressed: () {
//               //               setState(
//               //                 () {
//               //                   currentIndex = innerIndex;
//               //                 },
//               //               );
//               // BlocProvider.of<SliderCubit>(context)
//               //     .movePageTo(currentIndex);
//               //             },
//               //           ),
//               //           Text(
//               //             '',
//               //             style: AppStyles.h2Bold.copyWith(fontSize: 12),
//               //           ),
//               //           Text(
//               //             '',
//               //             style: AppStyles.h2Bold.copyWith(fontSize: 12),
//               //           ),
//               //         ],
//               //       ),
//               //     );
//               //   },
//               // ),

//               // List.generate(
//               //   widget.indicatorsOnPage == widget.indicatorsCount
//               //       ? widget.indicatorsCount
//               //       : widget.indicatorsCount + widget.indicatorsOnPage ~/ 2 + 1,
//               //   (index) {
//               //     final innerIndex = index % widget.indicatorsOnPage;
//               //     // debugPrint('innerIndex: ');
//               // return Indicator(
//               //   ownIndex: innerIndex,
//               //   currentIndex: currentIndex,
//               //   indicatorWidth: 15,
//               //   // (constraints.maxWidth -
//               //   //         4 * (widget.indicatorsOnPage - 1)) /
//               //   //     widget.indicatorsOnPage,
//               //   rightMargin: 4,
//               //   animationDuration: const Duration(
//               //     milliseconds: 300,
//               //   ),
//               //   onPressed: () {
//               //     setState(
//               //       () {
//               //         currentIndex = innerIndex;
//               //       },
//               //     );
//               //   },
//               // );
//               //   },
//               // ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void onEndScroll(ScrollNotification scroll) {}

//   void jumpTo(double offset) {
//     Future.delayed(
//       Duration.zero,
//       () => controller.jumpTo(
//         offset,
//       ),
//     );
//   }
// }

// class IndicatorsRow extends StatefulWidget {
//   final double spaceBetween;
//   final int indicatorsOnPage;
//   final int itemsCount;
//   final int pages;
//   final int itemsOnPage;
//   final Duration animationDuration;

//   const IndicatorsRow({
//     required this.itemsCount,
//     required this.itemsOnPage,
//     required this.pages,
//     required this.spaceBetween,
//     required this.indicatorsOnPage,
//     this.animationDuration = const Duration(
//       milliseconds: 300,
//     ),
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<IndicatorsRow> createState() => _IndicatorsRowState();
// }

// class _IndicatorsRowState extends State<IndicatorsRow> {
// TODO(Nikolay): Сделать универсальную формулу (без проверки widget.itemsCount / widget.itemsOnPage <= widget.indicatorsOnPage).
//   late final controller = ScrollController(
//     initialScrollOffset:
//         widget.itemsCount / widget.itemsOnPage <= widget.indicatorsOnPage
//             ? 0
//             : (currentGlobalIndex - 1) * (indicatorWidth + widget.spaceBetween),
//   );
//   late int pages;

//   late int currentGlobalIndex =
//       widget.itemsCount / widget.itemsOnPage <= widget.indicatorsOnPage ? 0 : 2;
//   late int currentInnerIndex = 0;
//   late int count;
//   late double indicatorWidth;

//   @override
//   void initState() {
//     super.initState();

//     pages = (widget.itemsCount / widget.itemsOnPage).ceil();

//     if (widget.itemsCount / widget.itemsOnPage <= widget.indicatorsOnPage) {
//       count = pages;
//     } else {
//       count = 8;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         indicatorWidth = (constraints.maxWidth - widget.spaceBetween * 2) / 3;

//         return BlocConsumer<SliderCubit, SliderState>(
//           listener: (context, state) {
//             if (state is SliderSlideTo) {
//               setState(
//                 () {
//                   currentGlobalIndex =
//                       (currentGlobalIndex + state.scrollPages) % count;
//                 },
//               );

//               Future.delayed(
//                 const Duration(
//                   milliseconds: 150,
//                 ),
//                 () => controller.animateTo(
//                   (currentGlobalIndex - 1) *
//                       (indicatorWidth + widget.spaceBetween),
//                   duration: widget.animationDuration * 2 ~/ 3,
//                   curve: Curves.easeOutQuart,
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             return NotificationListener<ScrollNotification>(
//               onNotification: (scroll) {
//                 if (scroll is ScrollEndNotification) {
//                   // onEndScroll(scroll);
//                 }
//                 return false;
//               },
//               child: ScrollConfiguration(
//                 behavior: NoGlowScrollBehavior(),
//                 child: SingleChildScrollView(
//                   // physics: const NeverScrollableScrollPhysics(),
//                   controller: controller,
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: List.generate(
//                       // widget.indexesOnPage + 2 + 1,
//                       // (i) {
//                       //   final innerIndex = (i + 1) % (widget.indexesOnPage);
//                       //   final currentInnerIndex =
//                       //       (currentGlobalIndex + 1) % (widget.indexesOnPage);

//                       /// _ _ - _ _ _ - _
//                       /// _ _ _ _ - _ _ _ _ _ - _
//                       ///

//                       // 5 + 3,
//                       // (i) {
//                       //   final innerIndex = (i + 1) % (5 - 1);
//                       //   final currentInnerIndex =
//                       //       (currentGlobalIndex + 1) % (5 - 1);

//                       // 8 - 3
//                       // 12 - 5
//                       count,
//                       (i) {
//                         // final innerIndex = (i + count - 2) % (pages + 1);
//                         // final currentInnerIndex =
//                         //     (currentGlobalIndex + 2) % (pages + 1);
//                         // (currentGlobalIndex + 2) % (pages + 1);
// TODO(Nikolay): Слабое место.
//                         final innerIndex = (i + count - 2) % pages;
//                         final currentInnerIndex =
//                             (currentGlobalIndex + count - 2) % pages;
//                         // final innerIndex =
//                         //     (i + count - widget.indicatorsOnPage) % (pages);
//                         // final currentInnerIndex =
//                         //     (currentGlobalIndex + widget.indicatorsOnPage) %
//                         //         (pages);

//                         return Column(
//                           children: [
//                             Indicator(
//                               ownIndex: innerIndex,
//                               currentIndex: currentInnerIndex,
//                               indicatorWidth: indicatorWidth,
//                               rightMargin:
//                                   i == count - 1 ? 0 : widget.spaceBetween,
//                               animationDuration: widget.animationDuration,
//                               onPressed: () {
//                                 if (i - currentGlobalIndex != 0) {
//                                   debugPrint('asd: ${i - currentGlobalIndex}');
//                                   BlocProvider.of<SliderCubit>(context)
//                                       .movePageBy(i - currentGlobalIndex);
//                                 }
//                               },
//                             ),
//                             Text(
//                               '$innerIndex',
//                               style: AppStyles.h2.copyWith(
//                                 fontSize: 10,
//                               ),
//                             ),
//                             Text(
//                               '$i',
//                               style: AppStyles.h2.copyWith(
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void onEndScroll(ScrollNotification scroll) {
// TODO(Nikolay): При увеличении количества индикаторов на странице начинает неправильно считать.
//     if (scroll.metrics.extentBefore < indicatorWidth + widget.spaceBetween) {
//       setState(
//         () {
//           currentGlobalIndex = pages * 2 -
//               (widget.indicatorsOnPage - 1) -
//               1; // 5; при pages == 4
//         },
//       );
//       jumpTo(
//         scroll.metrics.maxScrollExtent -
//             (indicatorWidth + widget.spaceBetween * (pages - 2)),
//         // scroll.metrics.maxScrollExtent -
//         //     (indicatorWidth + widget.spaceBetween * (pages - 1)),
//       );
//     }
//     if (scroll.metrics.extentAfter < indicatorWidth + widget.spaceBetween) {
//       setState(
//         () {
//           currentGlobalIndex =
//               pages - (widget.indicatorsOnPage - 1); // 2; при pages == 4
//         },
//       );
//       jumpTo(
//         (widget.indicatorsOnPage - 2) * (indicatorWidth + widget.spaceBetween),
//         // (pages ~/ 2) * (indicatorWidth + widget.spaceBetween),
//       );
//     }
//   }

//   void jumpTo(double offset) {
//     Future.delayed(
//       Duration.zero,
//       () => controller.jumpTo(
//         offset,
//       ),
//     );
//   }
// }
