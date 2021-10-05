import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class TextWithPoint extends StatelessWidget {
  final String text;
  const TextWithPoint({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '•',
          style: AppStyles.p1Grey,
        ),
        const SizedBox(
          width: 14,
        ),
        Flexible(
          child: Text(
            text,
            style: AppStyles.p1Grey,
          ),
        )
      ],
    );
  }
}
