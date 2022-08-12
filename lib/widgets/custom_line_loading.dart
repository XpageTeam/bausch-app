import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

// ignore: must_be_immutable
class CustomLineLoadingIndicator extends StatelessWidget {
  // только для домашнего экрана
  final String? text;
  late final int maximumScore;
  late int pointsToMaximum;

  CustomLineLoadingIndicator({
    required int maximumScore,
    this.text,
    int? pointsToMaximum,
    Key? key,
  }) : super(key: key) {
    this.maximumScore = maximumScore > 0 ? maximumScore : 1;
    if (pointsToMaximum != null) {
      this.pointsToMaximum = pointsToMaximum > maximumScore
          ? maximumScore
          : (pointsToMaximum < 0 ? 0 : pointsToMaximum);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userWm = Provider.of<UserWM>(context);

    return text != null
        ? Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedContainer(
                    curve: Curves.easeInOutCubic,
                    duration: const Duration(
                      milliseconds: 2500,
                    ),
                    height: 26,
                    width: constraints.maxWidth /
                        maximumScore *
                        (maximumScore - pointsToMaximum),
                    decoration: BoxDecoration(
                      color: AppTheme.sulu,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text!,
                    style: AppStyles.p1,
                  ),
                ],
              ),
            ],
          )
        : EntityStateBuilder<UserRepository>(
            streamedState: userWm.userData,
            builder: (_, userData) {
              pointsToMaximum =
                  maximumScore - userData.balance.available.toInt();
              return pointsToMaximum <= 0
                  ? const SizedBox.shrink()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          height: 26,
                          width: constraints.maxWidth / 1.8,
                          decoration: BoxDecoration(
                            color: AppTheme.mystic,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              AnimatedContainer(
                                curve: Curves.easeInOutCubic,
                                duration: const Duration(
                                  milliseconds: 2500,
                                ),
                                height: 26,
                                width: constraints.maxWidth /
                                    1.8 /
                                    maximumScore *
                                    (maximumScore - pointsToMaximum),
                                decoration: BoxDecoration(
                                  color: AppTheme.sulu,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              Center(
                                
                                child: Text(
                                  'Не хватает $pointsToMaximum б',
                                  style: AppStyles.h2,
                                 
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
            },
          );
  }
}
