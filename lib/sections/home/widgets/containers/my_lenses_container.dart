import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyLensesContainer extends StatelessWidget {
  const MyLensesContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const choseLenses = true;
    const putOnLenses = true;
    const lensesLife = 'День замен'; // день замены // просрочены
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      child: WhiteContainerWithRoundedCorners(
        onTap: () {
          // ignore: literal_only_boolean_expressions
          if (choseLenses) {
            Keys.mainContentNav.currentState!.pushNamed('/my_lenses');
          } else {
            Keys.mainContentNav.currentState!
                .pushNamed('/choose_lenses', arguments: [false]);
          }
        },
        padding: const EdgeInsets.only(
          left: StaticData.sidePadding,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Мои линзы',
                        style: AppStyles.h1,
                      ),
                      if (choseLenses)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Бауш',
                                style: AppStyles.p1,
                              ),
                              Text(
                                '500 дней',
                                style: AppStyles.p1,
                              ),
                            ],
                          ),
                        )
                      else
                        const Text(
                          'История ношения, сроки замены и параметры линз всегда под рукой',
                          style: AppStyles.p1,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: choseLenses
                      ? lensesLife == 'Живы'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                CircularPercentIndicator(
                                  radius: 25,
                                  animation: true,
                                  animationDuration: 2000,
                                  lineWidth: 6.0,
                                  percent: 0.75,
                                  center: const Text(
                                    '22',
                                    style: AppStyles.h1,
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  backgroundColor: AppTheme.mystic,
                                  progressColor: AppTheme.sulu,
                                ),
                                const Text(
                                  'Вс, 19 мая',
                                  style: AppStyles.n1,
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Container(
                                      height: 48,
                                      width: 48,
                                      decoration: const BoxDecoration(
                                        color: lensesLife == 'День замены'
                                            ? AppTheme.sulu
                                            : Color(0xffff7878),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        'assets/icons/loading.png',
                                        scale: 3,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 4),
                                    alignment: Alignment.topRight,
                                    child: const Text(
                                      'Замените\nлинзы',
                                      style: AppStyles.n1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                      : Image.asset(
                          'assets/my_lenses.png',
                          fit: BoxFit.scaleDown,
                        ),
                ),
              ],
            ),
            if (choseLenses)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: GreyButton(
                  text: putOnLenses ? 'Завершить ношение' : 'Надеть',
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: StaticData.sidePadding,
                  ),
                  onPressed: () {},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
