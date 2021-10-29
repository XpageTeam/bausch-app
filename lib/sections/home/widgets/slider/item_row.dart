import 'dart:math';

import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/home/widgets/default_catalog_item.dart';
import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemRow extends StatefulWidget {
  final List<CatalogItemModel> items;
  final int itemsOnPage;
  final double spaceBetween;
  final double maxWidth;
  final Duration animationDuration;

  const ItemRow({
    required this.items,
    required this.maxWidth,
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
    initialScrollOffset: (widget.maxWidth + 4) * 2,
  );

  late final SliderCubit sliderCubit;
  int currentPage = 2;

  final physics = BouncingScrollPhysics();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sliderCubit = BlocProvider.of<SliderCubit>(context);

    controller.addListener(
      () {
        final newPage = double.parse(
          (controller.offset / widget.maxWidth).toStringAsFixed(5),
        ).round();

        if (currentPage > newPage && currentPage - newPage < 3) {
          sliderCubit.slidePageTo(-1);
        }
        if (currentPage < newPage && currentPage - newPage > -3) {
          sliderCubit.slidePageTo(1);
        }

        setState(
          () {
            currentPage = newPage;
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

  late double oldOffset = (widget.maxWidth + 4) * 2;
  double velocity = 0.0;
  double maxVelocity = -1;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SliderCubit, SliderState>(
      listener: (context, state) {
        if (controller.hasClients && state is SliderMoveTo) {
          controller.animateTo(
            widget.maxWidth * (currentPage + state.direction) >
                    controller.position.maxScrollExtent
                ? controller.position.maxScrollExtent
                : (widget.maxWidth + 4) * (currentPage + state.direction),
            duration: widget.animationDuration,
            curve: Curves.linear,
          );
        }
      },
      builder: (context, state) {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              onEndScroll(scrollNotification.metrics);
              velocity = 0.0;
              maxVelocity = -1;
            }
            // if (scrollNotification is ScrollUpdateNotification) {
            //   velocity = (controller.offset - oldOffset).abs();
            //   oldOffset = controller.offset;

            //   if (maxVelocity < velocity) {
            //     maxVelocity = velocity;
            //   } else {
            //     if (scrollNotification.metrics.extentBefore <
            //         scrollNotification.metrics.extentInside + 4) {
            //       // debugPrint('left');
            //       // debugPrint('velocity $velocity');
            //       final end = scrollNotification.metrics.maxScrollExtent -
            //           scrollNotification.metrics.extentInside * 2 -
            //           3 * 4 +
            //           (scrollNotification.metrics.pixels -
            //               scrollNotification.metrics.extentInside);
            //       debugPrint(
            //         'before: ${controller.position.activity}',
            //       );
            //       jumpTo(end);
            //       controller.attach(position)

            //       // final activity = BallisticScrollActivity(
            //       //   controller.position.activity!.delegate,
            //       //   physics.createBallisticSimulation(
            //       //     controller.position,
            //       //     velocity,
            //       //   )!,
            //       //   this,
            //       // );

            //       // jumpTo(end).then(
            //       //   (value) => controller.position.beginActivity(activity),
            //       // );
            //     }

            //     if (scrollNotification.metrics.extentAfter <
            //         scrollNotification.metrics.extentInside + 4) {
            //       // debugPrint('right');
            //       // debugPrint('velocity $velocity');

            //       final start = scrollNotification.metrics.extentInside * 2 +
            //           3 * 4 +
            //           scrollNotification.metrics.extentInside +
            //           scrollNotification.metrics.pixels -
            //           scrollNotification.metrics.maxScrollExtent;

            //       jumpTo(start);
            //       // jumpTo(start).then(
            //       //   (value) => animateTo(controller.offset + velocity),
            //       // );
            //     }
            //   }
            // }

            return true;
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$currentPage',
                style: AppStyles.h2Bold,
              ),
              SingleChildScrollView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                physics: physics,
                child: IntrinsicHeight(
                  child: Row(
                    children: List.generate(
                      widget.items.length,
                      (i) => DefaultCatalogItem(
                        model: widget.items[i],
                        rightMargin: i == widget.items.length - 1 ? 0 : 4,
                        itemWidth: (widget.maxWidth - widget.spaceBetween) /
                            widget.itemsOnPage,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 10,
                    width: 3,
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    width: 3,
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void onEndScroll(ScrollMetrics metrics) {
    if (metrics.extentBefore < metrics.extentInside + 4) {
      debugPrint('leftTrigger');
      final end = metrics.maxScrollExtent -
          metrics.extentInside * 2 -
          3 * 4 +
          (metrics.pixels - metrics.extentInside);

      jumpTo(end);
    }
    if (metrics.extentAfter < metrics.extentInside + 4) {
      debugPrint('rightTrigger');
      final start = metrics.extentInside * 2 +
          3 * 4 +
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
