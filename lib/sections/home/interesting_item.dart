import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class InterestingItem extends StatelessWidget {
  const InterestingItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        width:
            MediaQuery.of(context).size.width / 2 - StaticData.sidePadding - 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: AspectRatio(
                  aspectRatio: 37 / 12,
                  child: Image.asset(
                    'assets/pic1.png',
                  )),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Раствор Biotrue универсальный(300 мл)',
              style: AppStyles.p1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 46,
              decoration: BoxDecoration(
                  color: AppTheme.mystic,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '13000',
                    style: AppStyles.h3,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  CircleAvatar(
                    child: Text(
                      'б',
                      style: TextStyle(
                          color: AppTheme.mineShaft,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          height: 20 / 17),
                    ),
                    radius: 14,
                    backgroundColor: AppTheme.turquoiseBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
