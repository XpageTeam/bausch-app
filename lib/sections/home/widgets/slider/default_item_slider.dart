import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/home/widgets/slider/cubit/slider_cubit.dart';
import 'package:bausch/sections/home/widgets/slider/indicators_row.dart';
import 'package:bausch/sections/home/widgets/slider/items_row.dart';
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
    this.indicatorsOnPage = 5,
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
          ItemsRow(
            animationDuration: const Duration(milliseconds: 500),
            itemsOnPage: widget.itemsOnPage,
            spaceBetween: widget.spaceBetween,
            items: scrollItems,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: IndicatorsRow(),
          ),
        ],
      ),
    );
  }
}
