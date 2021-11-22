import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/sections/home/widgets/custom_line_loading.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/point_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ScoresSection extends StatelessWidget {
  final Duration loadingAnimationDuration;
  final Duration delay;

  const ScoresSection({
    required this.loadingAnimationDuration,
    required this.delay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userWM = Provider.of<UserWM>(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EntityStateBuilder<UserRepository>(
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
                  ),
                );
              },
            ),
            const PointWidget(
              radius: 18,
              textStyle: TextStyle(
                color: AppTheme.mineShaft,
                fontWeight: FontWeight.w500,
                fontSize: 27,
                height: 25 / 27,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        FutureBuilder<int>(
          future: Future<int>.delayed(
            delay,
            () => 4,
          ),
          builder: (context, snapshot) {
            // TODO: посчитать и вывести
            return CustomLineLoadingIndicator(
              text: '127 баллов сгорят через 5 дней',
              maxDays: 15,
              remainDays: snapshot.hasData
                  ? snapshot.data!
                  : 5, // 20 = maxDays - future.value
              animationDuration: loadingAnimationDuration,
            );
          },
        ),
      ],
    );
  }
}
