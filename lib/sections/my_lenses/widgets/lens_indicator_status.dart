import 'dart:math';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LensIndicatorStatus extends StatelessWidget {
  final int daysBeforeReplacement;
  final int lifeTime;
  final VoidCallback onUpdateTap;
  final bool title;
  final bool sameTime;
  final bool isAloneChildCircle;
  final bool isLeft;
  const LensIndicatorStatus({
    required this.daysBeforeReplacement,
    required this.onUpdateTap,
    required this.lifeTime,
    this.title = true,
    this.isLeft = false,
    this.sameTime = false,
    this.isAloneChildCircle = false,
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
        if (daysBeforeReplacement > 0)
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
            linearGradient: sameTime
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    transform: GradientRotation(-2 * pi / 3),
                    colors: [
                      AppTheme.sulu,
                      AppTheme.turquoiseBlue,
                    ],
                  )
                : null,
            percent: percent.toDouble(),
            center: Padding(
              padding: EdgeInsets.only(top: isAloneChildCircle ? 10 : 7),
              child: Text(
                daysBeforeReplacement.toString(),
                style: title
                    ? AppStyles.h0
                    : AppStyles.h1.copyWith(fontSize: 45, height: 1),
              ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: AppTheme.mystic,
            progressColor: sameTime
                ? null
                : isLeft
                    ? AppTheme.turquoiseBlue
                    : AppTheme.sulu,
          )
        else
          GestureDetector(
            onTap: onUpdateTap,
            child: title == false
                ? SizedBox(
                    height: 145,
                    width: 145,
                    child: Center(
                      child: Container(
                        height: 130,
                        width: 130,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.redNotice,
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
                      SizedBox(
                        height: 192,
                        width: 192,
                        child: Center(
                          child: Container(
                            height: 177,
                            width: 177,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.redNotice,
                            ),
                            child: Center(
                              child: Text(
                                'Замените\nлинз${sameTime ? 'ы' : 'у'}',
                                style: AppStyles.h2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        if (sameTime == false)
          Padding(
            padding: EdgeInsets.only(top: !isAloneChildCircle ? 0 : 30),
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
                  color: isLeft ? AppTheme.turquoiseBlue : AppTheme.sulu,
                ),
                child: Center(
                  child: Text(isLeft ? 'L' : 'R', style: AppStyles.h2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
