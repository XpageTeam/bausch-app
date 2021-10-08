import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Widget? icon;
  const CustomFloatingActionButton({this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: AppTheme.turquoiseBlue,
            padding: const EdgeInsets.symmetric(
              horizontal: StaticData.sidePadding,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? Container(),
                const Text(
                  'Добавить баллы',
                  style: AppStyles.h2Bold,
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
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
        ),
      ],
    );
  }
}
