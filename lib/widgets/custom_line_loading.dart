import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

// ignore: must_be_immutable
class CustomLineLoadingIndicator extends StatelessWidget {
  // только для домашнего экрана
  final String? text;
  final bool isInList;
  late final int maximumScore;
  late int pointsToMaximum;

  CustomLineLoadingIndicator({
    required int maximumScore,
    this.text,
    this.isInList = false,
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
                  ? const SizedBox(height: 16)
                  : Padding(
                      padding: isInList ?
                          
                           const EdgeInsets.only(
                              left: StaticData.sidePadding,
                              right: StaticData.sidePadding,
                              top: 16,
                              bottom: 2,
                            ) :  EdgeInsets.zero,
                      child: SizedBox(
                        height: isInList ? 20 : 26,
                        child: LayoutBuilder(
                          builder: (widget, constraints) {
                            return Container(
                              width:
                                  isInList ? null : constraints.maxWidth / 1.85,
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

                                    // TODO(all): придумать как тут вычислять длинну
                                    // сейчас тут костыль
                                    width: isInList
                                        ? (MediaQuery.of(context).size.width /
                                                    2 -
                                                32) /
                                            maximumScore *
                                            (maximumScore - pointsToMaximum)
                                        : constraints.maxWidth /
                                            1.85 /
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
                                      style: isInList
                                          ? AppStyles.n1
                                          : AppStyles.h2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
            },
          );
  }
}
