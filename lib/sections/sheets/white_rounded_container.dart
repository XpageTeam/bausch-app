import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';

class WhiteRoundedContainer extends StatelessWidget {
  final Widget child;
  const WhiteRoundedContainer({required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.only(
        right: StaticData.sidePadding,
        left: StaticData.sidePadding,
        top: 20,
        bottom: 20,
      ),
      child: child,
    );
  }
}
