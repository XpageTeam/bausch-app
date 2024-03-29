import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/custom_line_loading.dart';
import 'package:bausch/widgets/point_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ScoresSection extends StatelessWidget {
  final Duration delay;

  const ScoresSection({
    required this.delay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userWM = Provider.of<UserWM>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37.0),
                child: EntityStateBuilder<UserRepository>(
                  streamedState: userWM.userData,
                  builder: (_, repo) {
                    return AutoSizeText(
                      repo.userScrore.toString(),
                      maxLines: 1,
                      style: const TextStyle(
                        color: AppTheme.mineShaft,
                        fontWeight: FontWeight.w500,
                        fontSize: 85,
                        height: 80 / 85,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    );
                  },
                ),
              ),
              const Positioned(
                right: 0,
                top: 1,
                child: PointWidget(
                  radius: 18,
                  textStyle: TextStyle(
                    color: AppTheme.mineShaft,
                    fontWeight: FontWeight.w500,
                    fontSize: 27,
                    height: 25 / 27,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
              ),
            ],
          ),
        ),
        EntityStateBuilder<UserRepository>(
          streamedState: userWM.userData,
          builder: (_, repo) {
            if (repo.canPrintLineLoadingText) {
              // if (repo.balance.nearestExpiration?.date != null)
              final daysRemain = repo.daysRemain ?? 10;

              return FutureBuilder<void>(
                future: Future.delayed(delay),
                builder: (_, s) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: CustomLineLoadingIndicator(
                      text: repo.lineLoadingText,
                      maximumScore: 365,
                      pointsToMaximum: s.connectionState == ConnectionState.done
                          ? daysRemain
                          : 364,
                   
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
