import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LensIndicatorStatus extends StatelessWidget {
  final String replacementDay;
  final VoidCallback onTap;
  final bool title;
  final bool left;
  const LensIndicatorStatus({
    required this.replacementDay,
    required this.onTap,
    this.title = true,
    this.left = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (replacementDay == 'Нет')
          CircularPercentIndicator(
            header: title
                ? const Padding(
                    padding: EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: Text(
                      'Дней до замены',
                      style: AppStyles.h2,
                    ),
                  )
                : const SizedBox(
                    height: 8,
                  ),
            radius: title ? 85 : 65,
            animation: true,
            animationDuration: 2000,
            lineWidth: 15.0,
            percent: 0.75,
            center: Text(
              '22',
              style: title
                  ? AppStyles.h0
                  : AppStyles.h1.copyWith(fontSize: 45, height: 1),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: AppTheme.mystic,
            progressColor: left ? AppTheme.turquoiseBlue : AppTheme.sulu,
          )
        else
          GestureDetector(
            onTap: onTap,
            child: title == false
                ? left
                    ? SizedBox(
                        height: 145,
                        width: 145,
                        child: Center(
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.turquoiseBlue,
                            ),
                            child: const Center(
                              child: Text(
                                'Замените\nлинзу',
                                style: AppStyles.h2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 145,
                        width: 145,
                        child: Center(
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.sulu,
                            ),
                            child: const Center(
                              child: Text(
                                'Замените\nлинзу',
                                style: AppStyles.h2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: Text(
                            replacementDay == 'Да'
                                ? 'День замены'
                                : 'День замены просрочен',
                            style: AppStyles.h2,
                          ),
                        ),
                      Stack(alignment: Alignment.center, children: [
                        if (replacementDay == 'Да')
                          Image.asset(
                            'assets/replacement_day.png',
                            scale: 2.53,
                          )
                        else
                          Image.asset(
                            'assets/replacement_day_overdue.png',
                            scale: 2.53,
                          ),
                        const Text(
                          'Замените\nлинзы',
                          style: AppStyles.h1,
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    ],
                  ),
          ),
        if (title == false)
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 33,
              width: 33,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                color: left ? AppTheme.turquoiseBlue : AppTheme.sulu,
              ),
              child: Center(child: Text(left ? 'L' : 'R', style: AppStyles.h2)),
            ),
          ),
      ],
    );
  }
}
