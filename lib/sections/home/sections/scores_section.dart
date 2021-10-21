import 'package:bausch/sections/home/widgets/custom_line_loading.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/animated_translate_opacity.dart';
import 'package:bausch/widgets/point_widget.dart';
import 'package:flutter/material.dart';

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '5600',
              style: TextStyle(
                color: AppTheme.mineShaft,
                fontWeight: FontWeight.w500,
                fontSize: 85,
                height: 80 / 85,
              ),
            ),
            PointWidget(
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
            () => 10,
          ),
          builder: (context, snapshot) {
            return CustomLineLoadingIndicator(
              maxDays: 30,
              remainDays: snapshot.hasData
                  ? snapshot.data!
                  : 20, // 20 = maxDays - future.value
              animationDuration: loadingAnimationDuration,
            );
          },
        ),
      ],
    );
  }
}
