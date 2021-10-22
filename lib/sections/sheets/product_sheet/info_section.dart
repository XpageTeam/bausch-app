import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 20,
          bottom: 40,
        ),
        child: Column(
          children: const [
            Text(
              'Однодневные контактные линзы из инновационного материала гипергель53, влагосодержание которого соответствует количеству воды в роговице глаза человека — 78%52.',
              style: AppStyles.p1,
            ),
          ],
        ),
      ),
    );
  }
}
