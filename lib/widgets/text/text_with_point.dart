import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class TextWithPoint extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const TextWithPoint({required this.text, this.style, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: style ?? AppStyles.p1Grey,
        ),
        const SizedBox(
          width: 14,
        ),
        Flexible(
          child: Text(
            text,
            style: style ?? AppStyles.p1Grey,
          ),
        )
      ],
    );
  }
}
