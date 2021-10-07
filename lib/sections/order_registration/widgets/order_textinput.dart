import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class OrderTextInput extends StatelessWidget {
  final String label;
  const OrderTextInput({
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          top: 10,
          bottom: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style: AppStyles.p1,
            ),
            const SizedBox(
              height: 6,
            ),
            const Text(
              'Саша',
              style: AppStyles.h2Bold,
            )
          ],
        ),
      ),
    );
  }
}
