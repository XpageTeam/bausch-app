// ignore_for_file: use_named_constants

import 'package:bausch/widgets/text/bulleted_list.dart';
import 'package:flutter/material.dart';

class LegalInfo extends StatelessWidget {
  final List<String> texts;
  final TextStyle? dotStyle;
  final TextStyle? textStyle;
  const LegalInfo({
    required this.texts,
    this.dotStyle,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: BulletedList(
                  list: [texts[i]],
                  dotStyle: dotStyle,
                  textStyle: textStyle,
                ),
              ),
            ],
          );
        },
        childCount: texts.length,
      ),
    );
  }
}
