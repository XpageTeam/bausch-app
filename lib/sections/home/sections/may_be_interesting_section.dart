import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/home/widgets/slider/indicator.dart';
import 'package:bausch/sections/home/widgets/slider/item_slider.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';

class MayBeInteresting extends StatefulWidget {
  final String text;
  const MayBeInteresting({
    this.text = 'Вам может быть интересно',
    Key? key,
  }) : super(key: key);

  @override
  State<MayBeInteresting> createState() => _MayBeInterestingState();
}

class _MayBeInterestingState extends State<MayBeInteresting> {
  late final items = Models.items.take(7).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.text,
            style: AppStyles.h1,
          ),
        ),
        const SizedBox(
          height: 20,
        ),

        // Слайдер с товаром
        ItemSlider<CatalogItemModel>(
          items: items,
          itemBuilder: (context, model) => CatalogItem(
            model: model,
            isProduct: true,
          ),
          indicatorBuilder: (context, isActive) => Indicator(
            isActive: isActive,
            animationDuration: const Duration(milliseconds: 300),
          ),
        ),
      ],
    );
  }
}
