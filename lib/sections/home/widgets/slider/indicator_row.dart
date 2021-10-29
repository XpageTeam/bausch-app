import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:bausch/sections/home/widgets/slider/indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndicatorRow extends StatefulWidget {
  final int pagesCount;
  final int indicatorsOnPage;
  final double spaceBetween;
  final double maxWidth;

  final Duration animationDuration;
  final int currentIndicatorsOnPage;

  const IndicatorRow({
    required this.pagesCount,
    required this.maxWidth,
    required this.animationDuration,
    this.indicatorsOnPage = 3,
    this.spaceBetween = 4,
    Key? key,
  })  : currentIndicatorsOnPage =
            indicatorsOnPage > pagesCount ? pagesCount : indicatorsOnPage,
        super(key: key);

  @override
  State<IndicatorRow> createState() => _IndicatorRowState();
}

class _IndicatorRowState extends State<IndicatorRow> {
  late final ScrollController controller = ScrollController(
    initialScrollOffset: widget.maxWidth + 4,
  );

  late double indicatorWidth;

  int currentIndex = 1;
  int oldPage = 2;

  @override
  void initState() {
    super.initState();
    indicatorWidth = (widget.maxWidth - widget.spaceBetween) /
        widget.currentIndicatorsOnPage;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SliderCubit, SliderState>(
      listener: (context, state) {
        var offset = 0.0;

        final temp = oldPage;
        // oldPage = state.page;

        if (controller.hasClients) {
          // if (widget.pagesCount <= widget.currentIndicatorsOnPage) {
          //   offset = 0;
          // } else {
          //   offset = ((1 / 3 * (widget.maxWidth - 4) + 4)+10) * state.page;
          // }

          // TODO(Nikolay): Переделать.
          // if (temp != state.page) {
          //   if (temp - state.page > 2) {
          //     final minOff =
          //         (1 / 3 * (widget.maxWidth - 4) + 4) * (state.page - 1);
          //     controller.jumpTo(
          //       minOff,
          //     );
          //   }
          //   if (temp - state.page < -2) {
          //     final minOff =
          //         (1 / 3 * (widget.maxWidth - 4) + 4) * (state.page + 1);
          //     controller.jumpTo(
          //       minOff,
          //     );
          //   }
          //   controller.animateTo(
          //     offset,
          //     duration: const Duration(
          //       milliseconds: 300,
          //     ),
          //     curve: Curves.linear,
          //   );
          // if ((temp - state.page).abs() > 2) {
          //   controller.jumpTo(
          //     offset,
          //   );
          // } else {
          //   controller.animateTo(
          //     offset,
          //     duration: const Duration(
          //       milliseconds: 300,
          //     ),
          //     curve: Curves.linear,
          //   );
          // }

          // }
        }
      },
      builder: (context, state) {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              // xz
            }
            return true;
          },
          child: Column(
            children: [
              SingleChildScrollView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                // physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  children: List.generate(
                    widget.pagesCount + 2,
                    (i) {
                      debugPrint(
                        '${(i + widget.pagesCount - 3) % (widget.pagesCount - 1)}',
                      );
                      return Indicator(
                        ownIndex: (i + widget.pagesCount - 3) %
                            (widget.pagesCount - 1),
                        // (i + widget.pagesCount - 1) % widget.pagesCount,
                        // currentIndex: state.page,
                        currentIndex: 2,
                        indicatorWidth: indicatorWidth,
                        rightMargin: 4,
                        animationDuration: widget.animationDuration,
                        onPressed: () {
                          BlocProvider.of<SliderCubit>(context).movePageTo(
                            (i + widget.pagesCount - 3) %
                                (widget.pagesCount - 1),
                            // (i + widget.pagesCount - 1) % widget.pagesCount,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// class OtherIndicator extends StatelessWidget {
//   final bool isCurrent;
//   final VoidCallback onPressed;

//   const OtherIndicator({
//     required this.isCurrent,
//     required this.onPressed,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         color: Colors.transparent,
//         child: AnimatedContainer(
//           color: isCurrent ? AppTheme.turquoiseBlue : Colors.white,
//           duration: const Duration(
//                 milliseconds: 300,
//               ) ~/
//               2,
//           width: 5,
//           height: 4,
//         ),
//       ),
//     );
//   }
// }

// class OtherIndicatorRow extends StatefulWidget {
//   final int page;
//   final int oldPage;
//   final void Function(int) callback;
//   const OtherIndicatorRow({
//     required this.page,
//     required this.oldPage,
//     required this.callback,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _OtherIndicatorRowState createState() => _OtherIndicatorRowState();
// }

// class _OtherIndicatorRowState extends State<OtherIndicatorRow> {
//   int currentIndex = 1;

//   @override
//   Widget build(BuildContext context) {
//     if (widget.page < widget.oldPage) playAnimation(0);
//     if (widget.page > widget.oldPage) playAnimation(2);

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         OtherIndicator(
//           isCurrent: currentIndex == 0,
//           onPressed: () => changePage(0),
//         ),
//         OtherIndicator(
//           isCurrent: currentIndex == 1,
//           onPressed: () {},
//         ),
//         OtherIndicator(
//           isCurrent: currentIndex == 2,
//           onPressed: () => changePage(2),
//         ),
//       ],
//     );
//   }

//   void changePage(int index) {
//     if (currentIndex < index) {
//       BlocProvider.of<SliderCubit>(context).movePageTo(widget.page + 1);
//     }
//     if (currentIndex > index) {
//       BlocProvider.of<SliderCubit>(context).movePageTo(widget.page - 1);
//     }

//     // playAnimation(index);
//   }

//   Future<void> playAnimation(int index) async {
//     widget.callback(widget.page);

//     setState(
//       () {
//         currentIndex = index;
//       },
//     );

//     await Future.delayed(
//       const Duration(
//             milliseconds: 300,
//           ) ~/
//           2,
//       () => setState(
//         () {
//           currentIndex = 1;
//         },
//       ),
//     );
//   }
// }
