import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LensIndicatorStatus extends StatelessWidget {
  final int daysBeforeReplacement;
  final int lifeTime;
  final VoidCallback onTap;
  final bool title;
  final bool sameTime;
  final bool twoLenses;
  final bool left;
  const LensIndicatorStatus({
    required this.daysBeforeReplacement,
    required this.onTap,
    required this.lifeTime,
    this.title = true,
    this.left = false,
    this.sameTime = false,
    this.twoLenses = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = daysBeforeReplacement >= lifeTime
        ? 1
        : daysBeforeReplacement / lifeTime;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // TODO(ask): какая-то лажа с датами происходит
        if (daysBeforeReplacement >= 0)
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
            percent: percent.toDouble(),
            center: Text(
              daysBeforeReplacement.toString(),
              style: title
                  ? AppStyles.h0
                  : AppStyles.h1.copyWith(fontSize: 45, height: 1),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: AppTheme.mystic,
            // TODO(all): не получается сделать разные цвета
            // пока оставил один
            progressColor: sameTime
                ? Colors.greenAccent
                : left
                    ? AppTheme.turquoiseBlue
                    : AppTheme.sulu,
          )
        else
          GestureDetector(
            onTap: onTap,
            child: title == false
                ? SizedBox(
                    height: 145,
                    width: 145,
                    child: Center(
                      child: Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: left ? AppTheme.turquoiseBlue : AppTheme.sulu,
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
                            daysBeforeReplacement == 0
                                ? 'День замены'
                                : 'День замены просрочен',
                            style: AppStyles.h2,
                          ),
                        ),
                      Stack(alignment: Alignment.center, children: [
                        if (daysBeforeReplacement == 0)
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
        if (sameTime == false)
          Padding(
            padding: EdgeInsets.only(top: !twoLenses ? 30 : 0),
            child: Align(
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
                child:
                    Center(child: Text(left ? 'L' : 'R', style: AppStyles.h2)),
              ),
            ),
          ),
      ],
    );
  }
}
