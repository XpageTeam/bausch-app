import 'package:bausch/sections/home/interesting_item.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class MayBeInteresting extends StatelessWidget {
  const MayBeInteresting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Вам может быть интересно',
          style: AppStyles.h2,
        ),
        SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [InterestingItem(), InterestingItem(), InterestingItem()],
          ),
        )
      ],
    );
  }
}
