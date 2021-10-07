import 'package:bausch/sections/home/widgets/custom_line_loading.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ScoresSection extends StatelessWidget {
  const ScoresSection({Key? key}) : super(key: key);

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
            CircleAvatar(
              backgroundColor: AppTheme.turquoiseBlue,
              radius: 18,
              child: Text(
                'б',
                style: TextStyle(
                  color: AppTheme.mineShaft,
                  fontWeight: FontWeight.w500,
                  fontSize: 27,
                  height: 25 / 27,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const CustomLineLoadingIndicator(),
      ],
    );
  }
}
