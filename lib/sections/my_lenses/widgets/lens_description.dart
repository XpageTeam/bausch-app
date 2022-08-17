import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/cupertino.dart';

class LensDescription extends StatelessWidget {
  final String title;
  const LensDescription({required this.title,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 41,
          width: 41,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(160)),
            color: AppTheme.mystic,
          ),
          child: Center(child: Text(title,style: AppStyles.h1,)),
        ),
        const SizedBox(width: 10),
        Column(
          children: const [
            Text(
              'пункт 1',
              style: AppStyles.p1,
            ),
            Text(
              'пункт 2',
              style: AppStyles.p1,
            ),
            Text(
              'пункт 3',
              style: AppStyles.p1,
            ),
            Text(
              'пункт 4',
              style: AppStyles.p1,
            ),
            Text(
              'пункт 5',
              style: AppStyles.p1,
            ),
          ],
        ),
      ],
    );
  }
}
