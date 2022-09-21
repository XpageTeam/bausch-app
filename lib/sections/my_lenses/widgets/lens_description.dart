import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/cupertino.dart';

class LensDescription extends StatelessWidget {
  final String title;
  final PairModel pairModel;
  const LensDescription({
    required this.title,
    required this.pairModel,
    Key? key,
  }) : super(key: key);

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
          child: Center(
            child: Text(
              title,
              style: AppStyles.h1,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BC: ${pairModel.basicCurvature}',
              style: AppStyles.p1,
            ),
            Text(
              'Аддидация: ${pairModel.addition}',
              style: AppStyles.p1,
            ),
            Text(
              'D: ${pairModel.diopters}',
              style: AppStyles.p1,
            ),
            Text(
              'CYL: ${pairModel.cylinder}',
              style: AppStyles.p1,
            ),
            Text(
              'AXIS: ${pairModel.axis}',
              style: AppStyles.p1,
            ),
          ],
        ),
      ],
    );
  }
}
