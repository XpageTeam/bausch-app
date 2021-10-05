import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/points_info.dart';
import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  const TopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 64,
                ),
                Image.asset(
                  'assets/free-packaging.png',
                  height: MediaQuery.of(context).size.height / 5,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Раствор Biotrue универсальный (300 мл)',
                  style: AppStyles.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                const ButtonContent(price: '1300'),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const PointsInfo(text: 'Не хватает 2000'),
                CircleAvatar(
                  backgroundColor: AppTheme.mystic,
                  radius: 22,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.close,
                        color: AppTheme.mineShaft,
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
