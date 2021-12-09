// ignore_for_file: use_named_constants

import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/text/text_with_point.dart';
import 'package:flutter/material.dart';

class LegalInfo extends StatelessWidget {
  final List<String> texts;
  const LegalInfo({required this.texts, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextWithPoint(
                  text: texts[i],
                  dotStyle: AppStyles.p1.copyWith(
                    color: AppTheme.mineShaft,
                  ),
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
