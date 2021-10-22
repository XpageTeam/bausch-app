import 'package:bausch/sections/home/widgets/slider/indicator.dart';
import 'package:flutter/material.dart';

class IndicatorRow extends StatelessWidget {
  final int currentIndex;
  final int count;
  const IndicatorRow({
    required this.currentIndex,
    required this.count,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        count,
        (i) => i - 1 == count
            ? Indicator(
                ownIndex: i,
                currentIndex: currentIndex,
              )
            : Padding(
                padding: const EdgeInsets.only(
                  right: 4,
                ),
                child: Indicator(
                  ownIndex: i,
                  currentIndex: currentIndex,
                ),
              ),
      ),
    );
  }
}
