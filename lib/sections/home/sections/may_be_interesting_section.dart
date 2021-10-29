import 'package:bausch/sections/home/widgets/slider/default_item_slider.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class MayBeInteresting extends StatefulWidget {
  const MayBeInteresting({Key? key}) : super(key: key);

  @override
  State<MayBeInteresting> createState() => _MayBeInterestingState();
}

class _MayBeInterestingState extends State<MayBeInteresting> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Вам может быть интересно',
            style: AppStyles.h1,
          ),
        ),
        const SizedBox(
          height: 20,
        ),

        // Слайдер с товаром
        CustomItemSlider(
          items: Models.items.take(12).toList(),
          animationDuration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }
}
