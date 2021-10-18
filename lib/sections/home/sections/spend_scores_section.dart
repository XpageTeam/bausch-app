import 'package:bausch/sections/home/widgets/small_container.dart';
import 'package:bausch/sections/home/widgets/wide_container.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class SpendScores extends StatelessWidget {
  const SpendScores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Потратить баллы',
          style: AppStyles.h1,
        ),
        const SizedBox(
          height: 20,
        ),
        WideContainer(
          sheetModel: Models.sheets[0],
          children: const [
            'assets/logos/logo1.png',
            'assets/logos/logo2.png',
            'assets/logos/logo3.png',
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            SmallContainer(
              sheetModel: Models.sheets[1],
            ),
            const SizedBox(
              width: 4,
            ),
            SmallContainer(
              sheetModel: Models.sheets[2],
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            SmallContainer(
              sheetModel: Models.sheets[3],
            ),
            const SizedBox(
              width: 4,
            ),
            SmallContainer(
              sheetModel: Models.sheets[4],
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        WideContainer(
          sheetModel: Models.sheets[5],
        ),
      ],
    );
  }
}
