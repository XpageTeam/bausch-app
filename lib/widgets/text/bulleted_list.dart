import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class BulletedList extends StatelessWidget {
  final List<String> list;
  final TextStyle? dotStyle;
  final TextStyle? textStyle;
  const BulletedList({
    required this.list,
    this.dotStyle,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        list.length,
        (i) => Padding(
          padding: EdgeInsets.only(
            bottom: i != list.length - 1 ? 10.0 : 0.0,
          ),
          child: BulletedRow(text: list[i]),
        ),
      ),
    );
  }
}

class BulletedRow extends StatelessWidget {
  final String text;
  const BulletedRow({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.mineShaft,
            borderRadius: BorderRadius.circular(180),
          ),
          width: 4,
          height: 4,
        ),
        // Text(
        //   '.',
        //   style: AppStyles.p1,
        // ),
        const SizedBox(
          width: 14,
        ),
        Flexible(
          child: Text(
            text,
            style: AppStyles.p1,
          ),
        ),
      ],
    );
  }
}
