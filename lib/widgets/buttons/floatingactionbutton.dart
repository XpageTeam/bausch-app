import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width - StaticData.sidePadding * 2,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: AppTheme.turquoiseBlue,
                padding: const EdgeInsets.symmetric(
                    horizontal: StaticData.sidePadding)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                  color: AppTheme.mineShaft,
                ),
                SizedBox(
                  width: 9,
                ),
                Text(
                  'Добавить баллы',
                  style: AppStyles.h3,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 60,
          color: AppTheme.mystic,
          child: const Center(
            child: Text(
              'Имеются противопоказания, необходимо проконсультироваться со специалистом',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.grey,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 16 / 14,
              ),
            ),
          ),
        )
      ],
    );
  }
}
