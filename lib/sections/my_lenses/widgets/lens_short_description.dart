import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/cupertino.dart';

class LensShortDescription extends StatelessWidget {
  final bool isLeft;
  final PairModel pairModel;
  const LensShortDescription({
    required this.isLeft,
    required this.pairModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strings = <String>[];
    if (pairModel.basicCurvature != null) {
      strings.add('BC: ${pairModel.basicCurvature} mm');
    }
    if (pairModel.addition != null) {
      strings.add('ADD: ${pairModel.addition}');
    }
    if (pairModel.diopters != null && strings.length < 2) {
      strings.add('D: ${pairModel.diopters}');
    }
    if (pairModel.cylinder != null && strings.length < 2) {
      strings.add('CYL: ${pairModel.cylinder}');
    }
    if (pairModel.axis != null && strings.length < 2) {
      strings.add('AXIS: ${pairModel.axis}');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(160)),
            color: isLeft ? AppTheme.turquoiseBlue : AppTheme.sulu,
          ),
          child: Center(
            child: Text(
              isLeft ? 'L' : 'R',
              style: AppStyles.p2,
            ),
          ),
        ),
        const SizedBox(height: 4),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: strings.length,
          itemBuilder: (_, index) => Text(
            strings[index],
            style: AppStyles.p1Grey,
          ),
        ),
      ],
    );
  }
}
