import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class TextWithPoint extends StatelessWidget {
  final String text;
  final TextStyle? dotStyle;
  final TextStyle? textStyle;
  const TextWithPoint({
    required this.text,
    this.dotStyle,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: dotStyle ?? AppStyles.p1Grey,
        ),
        const SizedBox(
          width: 14,
        ),
        Flexible(
          child: Text(
            text,
            style: textStyle ?? AppStyles.p1Grey,
          ),
        ),
      ],
    );
  }
}
