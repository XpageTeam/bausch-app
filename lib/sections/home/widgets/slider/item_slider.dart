import 'dart:math';

import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:bausch/sections/home/widgets/slider/indicators_row.dart';
import 'package:bausch/sections/home/widgets/slider/items_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemSlider<T> extends StatefulWidget {
  final List<T> items;
  final Duration animationDuration;
  final int indicatorsOnPage;
  final double spaceBetween;

  final ItemBuilder<T> itemBuilder;
  final IndicatorBuilder indicatorBuilder;

  int itemsOnPage;

  ItemSlider({
    required this.items,
    required this.itemBuilder,
    required this.indicatorBuilder,
    int itemsOnPage = 2,
    this.indicatorsOnPage = 3,
    this.spaceBetween = 4,
    this.animationDuration = const Duration(milliseconds: 300),
    Key? key,
  })  : itemsOnPage = min(itemsOnPage, items.length),
        assert(itemsOnPage > 0),
        assert(indicatorsOnPage > 0),
        assert(spaceBetween > 0),
        super(key: key);

  @override
  _ItemSliderState<T> createState() => _ItemSliderState<T>();
}

class _ItemSliderState<T> extends State<ItemSlider<T>> {
  late final int additionalItems = widget.itemsOnPage;

  late final initPage = additionalItems - 1;
  late final SliderCubit sliderCubit = SliderCubit();
  // late List<T> scrollItems;
  @override
  void initState() {
    super.initState();
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
            builder: (context, constraints) => ItemsRow<T>(
              maxWidth: constraints.maxWidth,
              animationDuration: widget.animationDuration,
              itemsOnPage: widget.itemsOnPage,
              spaceBetween: widget.spaceBetween,
              builder: widget.itemBuilder,
              items: widget.items,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0),
            child: LayoutBuilder(
              builder: (context, constraints) => IndicatorsRow(
                maxWidth: constraints.maxWidth,
                animationDuration: widget.animationDuration,
                indicatorsOnPage: widget.indicatorsOnPage,
                spaceBetween: widget.spaceBetween,
                builder: widget.indicatorBuilder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
